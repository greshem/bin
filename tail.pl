#!/usr/bin/perl -w

#
# A Perl implementation of tail for the Perl Power Tools project by
# Thierry Bezecourt <thbzcrt@worldnet.fr>. Includes an implementation
# of Chip Rosenthal's xtail.
#
# Please see the pod documentation at the end of this file.
#
# 99/03/07 : implemented xtail in the -f option
# 99/03/03 : fixed the -f option which was completely broken
# 99/03/02 : first version
#

$| = 1;

use Getopt::Long;  # because of some special handling on numeric options

use strict;
use vars qw($opt_b $opt_c $opt_f $opt_h $opt_n $opt_r);

use File::Basename;
my $me = basename $0;

sub usage($;$)
{
    print STDERR "$_[1]\n" if $_[1];
    print STDERR <<EOF;
Usage: 
    tail [-f | -r] [-h] [-b number | -c number | -n number | [-+]number] 
        [file ...]
    xtail [-h] file ...
EOF
    exit $_[0];
}

# Maybe I should use stat() to retrieve the block size ? But the BSD man
# page says "512"
my $block_size = 512;

# Command-line parsing

sub check_number($)
{
    my $opt = shift;
    if ($opt =~ /\+(\d+)$/) {
	return $1+0;
    } elsif      ($opt =~ /-?(\d+)$/) {
	return -($1+0);
    } else {
	usage(1);
    }
}

sub parse_args()
{
    my $files;
    my $point=-10;
    my $type="n"; # one of "b", "c" or "n"

    # If called as xtail, then no option is used except -h
    if ($me eq "xtail") {
	
	GetOptions("h");
	usage 0 if $opt_h;

    } else {

	# special handling for -numeric options
        Getopt::Long::config("pass_through");
	GetOptions("b=s", "c=s", "f", "h", "n=s", "r");

	usage 0 if $opt_h;
	usage 1, "-f and -r cannot be used together"
	    if $opt_f and $opt_r;

	$point = check_number($opt_b), $type = "b" if $opt_b;
	$point = check_number($opt_c), $type = "c" if $opt_c;
	$point = check_number($opt_n), $type = "n" if $opt_n;

	for (@ARGV) {
	    $point = check_number($1), shift @ARGV, last 
		if /^([-+].*)$/;
	}

	usage 1, "The number cannot be null" if $point == 0;
	
	$point = $point ? $point : -10;
    }
    
    $files = [ @ARGV ];

    return ($point, $type, $files);
}

# Prints the tail of a file according to the options passed on the
# command line.
sub print_tail(*$$$)
{
    my ($fh, $f, $point, $type) = @_;

    # default starting point is -10
    my $p = $point;

    my $i=0;
    my @buf;
    
    if($type eq "n") {  # line
	
	if($p > 0) { # start from the beginning of the file

 	    if($opt_r) {  # reverse
		while($p-- and ($_ = <$fh>)) {
		    $buf[$p] = $_;
		}
		for (@buf[ ($p+1) .. $#buf ]) {
		    print;
		}
	    } else {      # non reverse
		while(--$p and <$fh>) { }
		if($p == 0) {
		    while(<$fh>) {
			print;
		    }
		}
	    }

	} else {    # start from the end of the file

	    while(<$fh>) {
		$i++;
		$buf[$i%(-$p)] = $_;
	    }
	    my @tail = (@buf[ ($i%(-$p) + 1) .. $#buf ], 
			@buf[  0 .. $i%(-$p) ]);
	    @tail = reverse @tail if $opt_r;
	    for (@tail) {
		print if $_; # @tail may begin or end with undef
	    }
	}

    } elsif ($type eq "c" or $type eq "b") {  # character or block
	if($p > 0) {   # start from the beginning of the file
 
	    if($opt_r) {  # reverse
		if($type eq "c") {
		    while($p-- and ($_ = getc $fh)) {
			$buf[$p] = $_;
		    }
		} else {
		    while($p-- and read($fh, $_, $block_size)) { 
			$buf[$p] = $_;
		    }
		}
		for (@buf[ ($p+1) .. $#buf ]) {
		    print;
		}
	    } else {       # non reverse
		if($type eq "c") {
		    while(--$p and getc $fh) { }
		} else {
		    while(--$p and read($fh, $_, $block_size)) { }
		}
		
		if($p == 0) {
		    while(read $fh, $_, $block_size) {
			print;
		    }
		}
	    }

	} else {  # start from the end of the file

 	    if($type eq "c") {
		seek $fh, $p, 2;
	    } else {
		seek $fh, $p*$block_size, 2;
	    }
	    if($opt_r) {   # reverse
		if($type eq "c") {
		    print scalar reverse <$fh>;
		} else {
		    while($p++ and read($fh, $_, $block_size)) {
			$buf[-$p] = $_;
		    }
		    for (@buf[ (-$p+1) .. $#buf ]) {
			print;
		    }
		}
	    } else {   # non reverse
		while(read $fh, $_, $block_size) {
		    print;
		}
	    }
	    
	}
    }
}

# Make these variables global in order to use them in &handler_INT
my %info;
my @filelist;
my @dirlist;

sub get_existing_files(\@\@)
{
    my ($filelist, $dirlist) = @_;

    my @files = grep { -e $_ } @$filelist;
    
    for my $d(@$dirlist) {
	opendir(DIR, $d) or die "can't open directory $d: $!";
	push @files, map { "$d/$_" } grep { -f "$d/$_" } readdir(DIR);
	closedir DIR;
    }

    # Remove the duplicates.
    my %saw;
    return grep(!$saw{$_}++, @files);
}

# -f option : monitor several files
#
# Algorithm : each second, we compare the size of each file with the size of
# the file one second before. If it is different, we reopen the file and 
# print the difference. It might be nice to keep some file handles open for
# a while, but opening and reopening hundreds of file each seconds seems to
# work pretty well on my Linux box. According to comments in the
# xtail C source code, improvements could be obtained using fstat() on file
# handles instead of stat(). I'll do something if people need it.

sub tail_f(\@\@$$)
{
    @filelist = @{shift @_};
    @dirlist = @{shift @_};
    my ($point, $type) = @_;

    local $SIG{'INT'}  = \&handle_INT;
    local $SIG{'QUIT'} = sub { exit 0 }; # do not core dump

    my ($ino, $size, $mtime);

    map { 
	(undef, $ino, undef, undef, undef, undef, undef, $size, 
	 undef, $mtime) = stat($_);
	$info{$_} = [$ino, $size, $mtime];
    } get_existing_files(@filelist, @dirlist);

    my $current;

    while(1) {

	# Add newly created files
	map {
	    unless(exists $info{$_}) {
		print "\n*** '$_' has been created ***\n";
		(undef, $ino, undef, undef, undef, undef, undef, $size, 
		 undef, $mtime) = stat($_);
		# Set size to zero to print the whole new file
		$info{$_} = [$ino, 0, $mtime];
	    }
	} get_existing_files(@filelist, @dirlist);

	# Loop on files
	for my $file (keys %info) {

	    if(-e $file) {

		my ($oldino, $oldsize, $oldmtime) = @{ $info{$file} };
		
		# get fresh information on the file
		(undef, $ino, undef, undef, undef, undef, undef, $size, 
		 undef, $mtime) = stat($file);
		
		# Removed the check on the mtime, because a program which send
		# its output to the file may change the mtime of the file at
		# some moment without actually sending data, and thus without
		# changing the size of the file.
		# if( $ino != $oldino or $size < $oldsize or 
		#    ($size == $oldsize and $mtime > $oldmtime))
		if( $ino != $oldino or $size < $oldsize)
		{
		    # The file has probably been completely changed,
		    # we reopen it and read the last lines.
		    open FH, $file or 
			do {print STDERR 
				"Couldn't reopen $file for reading: $!\n";
			    exit 1;};
		    print "\n*** '$file' has been truncated or replaced ***\n";
		    print "\n*** $file ***\n";
		    $current = $file;
		    print_tail \*FH, $file, $point, $type;
		    close FH;
		} 
		elsif($size > $oldsize)
		{
		    # Only some data has been appended. We print them.
		    open FH, $file or
			do {print STDERR 
				"Couldn't reopen $file for reading: $!\n";
			    exit 1;};

		    seek FH, ($oldsize - $size), 2;
		    read FH, $_, $size - $oldsize;
		    print("\n*** $file ***\n"), $current = $file 
			unless(defined($current) and $current eq $file);
		    print;

		    close FH;
		}

		$info{$file} = [$ino, $size, $mtime];

	    } else {
		print "\n*** '$file' has been deleted ***\n";
		delete $info{$file};
	    }
	}

	sleep 1;
    }
}

# Prints the recently changed files, the most recent first
sub handle_INT()
{
    print "\n*** recently changed files ***\n";

    my $f;
    my $i=1;
    for $f (reverse sort { $info{$a}[2] <=> $info{$b}[2] } 
	    keys %info) {
	print sprintf("%3d  %s  %s", 
		      $i, scalar localtime($info{$f}[2]), $f)."\n";
	$i++;
    }
    my @existing = get_existing_files(@filelist, @dirlist);
    my @unknown = grep {! -e $_} @filelist;

    print "currently watching: ".
	sprintf("%3d files %3d dirs %3d unknown entries\n",
		scalar @existing, scalar @dirlist, scalar @unknown);

    # On some systems (NT, for instance), it is necessary to 
    # reinstall the signal handler
    $SIG{'INT'} = \&handle_INT;
}

#
# Main function
#
sub handle_args($$$)
{
    my ($point, $type, $files_) = @_;

    # Expand the directories (but not the sub-directories)
    my @files;
    my @dirs;
    my $f;
    for $f (@$files_) {
	if(-d $f) {
	    push @dirs, $f;
	} else {
	    push @files, $f;
	}
    }

    if(scalar @files >= 1 or scalar @dirs >= 1) {
	my $i=0;

	# Ignore the directories
	my $file;
	for $file (@files) {
	    
	    # do not die if the file does not exist, when -f is used
	    next if(!-e $file and ($opt_f or $me eq "xtail"));

	    open FH, "< $file"
		or do { print STDERR 
			    "Couldn't open $file for reading: $!\n"; 
			    exit 1 }; 

	    # Do not print the tail of the files if we are using xtail
	    unless($me eq "xtail") {
		print "*** $file ***\n" if(scalar @files >= 2);
		print_tail \*FH, $file, $point, $type;
		print "\n" if(++$i < scalar(@files));
	    }

	    close FH;
	}
	
	if($opt_f or ($me eq "xtail")) {
	    tail_f(@files, @dirs, $point, $type);
	}

    } else {
	print_tail \*STDIN, "stdout", $point, $type;
	# Ignore the -f option
    }
    
}

my ($point, $type, $files) = parse_args();
handle_args($point, $type, $files);

exit 0;

__END__

=head1 NAME

tail - display the last part of a file

xtail - watch the growth of files

=head1 SYNOPSIS

tail [B<-f> | B<-r>] [B<-b number> | B<-c number> | B<-n number> |
B<[-+]number>] [B<file>...]

xtail [B<-h>] file ...

=head1 DESCRIPTION

The I<tail> utility displays the contents of B<file> or, by default,
its standard input, to the standard output.

The display begins at a byte, line or 512-byte block location in the
input.  Numbers having a leading plus (B<+>) sign are relative to the
beginning of the input, for example, B<-c +2> starts the display at
the second byte of the input.  Numbers having a leading minus (B<->)
sign or no explicit sign are relative to the end of the input, for
example, B<-n 2> displays the last two lines of the input.  The
default starting location is B<-n 10>, or the last 10 lines of the
input.

The I<xtail> utility monitors one or more files, and displays all data
written to a file since command invocation.  It is very useful for
monitoring multiple logfiles simultaneously.  It may be invoked by
renaming I<tail> to I<xtail>, or by calling I<tail> with the B<-f>
option.

With I<xtail> or I<tail -f>, if an entry given on the command line is
a directory, all files in that directory will be monitored, including
those created after the invocation.  If an entry given on the command
line doesn't exist, the program will watch for it and monitor it once
created.  When switching files in the display, a banner showing the
pathname of the file is printed.

An interrupt character (usually CTRL/C or DEL) will display a list of
the most recently modified files being watched.  Send a quit signal
(usually CTRL/backslash) to stop the program.

The options are the following for I<tail> (only the B<-h> option is
supported by I<xtail>) :

=over 4

=item B<-b number>

The location is B<number> 512-byte blocks.

=item B<-c number>

The location is B<number> bytes.

=item B<-f>

The B<-f> option causes I<tail> to not stop when end-of-file is reached,
but rather to wait for additional data to be appended to the input.
If the file is replaced (ie. the inode number changes), I<tail> will
reopen the file and continue.  If the file is truncated, I<tail> will
reset its position back to the beginning.  This makes I<tail> more useful
for watching log files that may get rotated.  The B<-f> option is
ignored if the standard input is a pipe, but not if it is a FIFO.

=item B<-h>

Displays a short usage message.

=item B<-n> number

The location is B<number> lines.

=item B<-r>

The B<-r> option causes the input to be displayed in reverse order, by
line.  Additionally, this option changes the meaning of the B<-b>,
B<-c> and B<-n> options.  When the B<-r> option is specified, these
options specify the number of bytes, lines or 512-byte blocks to
display, instead of the bytes, lines or blocks from the beginning or
end of the input from which to begin the display.  The default for the
B<-r> option is to display all of the input.

=item B<-ddd> where B<ddd> is an integer

Same as B<-n ddd>.

=back

If more than a single file is specified, each file is preceded by a
header consisting of the string ``*** XXX ***'' where ``XXX'' is the
name of the file.

This header also appears with the B<-f> option, when the file inode
has changed.

The I<tail> utility exits 0 on success or >0 if an error occurred.

=head1 SEE ALSO

cat(1), head(1), sed(1)

=head1 STANDARDS

The I<tail> utility is expected to be a superset of the IEEE
Std1003.2-1992 (``POSIX.2'') specification.  In particular, the B<-b>
and B<-r> options are extensions to that standard.

The historic command line syntax of I<tail> is supported by this
implementation.  The only difference between this implementation and
historic versions of I<tail>, once the command line syntax translation
has been done, is that the B<-b>, B<-c> and B<-n> options modify the
-r option, i.e.  B<-r -c 4> displays the last 4 characters of the last
line of the input, while the historic I<tail> (using the historic syntax
B<-4cr>) would ignore the B<-c> option and display the last 4 lines of
the input.

=head1 HISTORY

A I<tail> command appeared in Version 7 AT&T UNIX.

The original version of I<xtail> was written by Chip Rosenthal.

=head1 BUGS

This implementation of I<tail> and I<xtail> has no known bugs. However
it has not been completely tested on all systems (yet).

=head1 NOTES

The I<xtail> implementation opens and reopens file handles very
often. It works pretty well on my system, but tell me if you have
problems monitoring directories with hundreds of log files which vary
very often.

Since I<tail -f> or I<xtail> catches the INT signals (CTRL-C), the
program must be stopped a QUIT signal (CTRL-D) or by some other means,
for instance CTRL-Pause on Windows.

=head1 AUTHOR

The Perl implementation was written by Thierry Bezecourt,
I<thbzcrt@worldnet.fr>. Perl Power Tools project, March 1999.

This documentation comes from the BSD tail(1) man page and from the
xtail man page. The integration of xtail was Tom Christiansen's idea.

=head1 COPYRIGHT and LICENSE

This program is free and open software. You may use, modify, distribute,
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others from doing the same.

=cut

