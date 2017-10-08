#!/usr/bin/env perl
#   
#  split -- split a file into pieces
#
#        Rich Lafferty <rich@alcor.concordia.ca> 
#        Sat Mar  6 22:27:28 EST 1999
#
#   Perl Power Tools -- http://language.perl.com/ppt/
# 

$^W = 1;  # -w
use strict;
use Getopt::Std;
use File::Basename;

my $me = basename($0);

## get_count expands byte/linecount 'k' and 'm' and checks sanity
sub get_count {
    my $count = shift;

    return undef unless $count =~ /^\d+[KkMm]?$/;   # sane?
    
    if ($count =~ /[Kk]$/) {
	$count =~ s/[Kk]//g;
	$count *= 1024;
    } elsif ($count =~ /[Mm]$/) {
	$count =~ s/[Mm]//g;
	$count *= 1024 * 1024;
    }

    return $count;
}

# nextfile creates the next file for output, and returns the 
# typeglob of the filehandle. This is the part to hack if your OS's
# filenames are broken (8.3, for example, or RISC/OS's `.' path
# separator.

sub nextfile {
    no strict 'vars';
    package nextfile; 

    my $prefix = shift;
    
    if (! fileno(FH)) {
	$curext = "aaa";   # initialize on first call
    } 
    else {
	
	close FH or die "$me: Can't close $curname: $!\n";
	
	if ($curext eq "zzz") { die "$me: can only create 17576 files\n" }
    	else { $curext++ }

    }

    # MS-DOS: $curname = "$prefix." . $curext; 
    $curname = $prefix . $curext;
    open (FH, ">$curname") or die "$me: Can't open $curname: $!\n";
    binmode(FH);
    return *FH;
}

## clue explains usage.
sub clue {

    print <<EOT;
usage: $me -b byte_count[k|m] [file [prefix]]
       $me -l line_count[k|m] [file [prefix]] 
       $me -p regexp [file [prefix]]

Output fixed-size pieces of INPUT to prefixaaa, prefixabb, ...; default
prefix is 'x'.  With no file, or when file is -, read standard input.

SIZE may have a multiplier suffix: k for 1024, m for 1024^2.

EOT

exit 1;
}

#### Main program starts here. ####

## Grab options
getopts ('b:l:p:?', \my %opt);

clue if $opt{"?"};    # heeeeeeeeeeelp! 

## Open whatever needs opening
my $infile = (defined $ARGV[0] ? $ARGV[0] : "-");
my $prefix = ($ARGV[1] ? "$ARGV[1]" : "x");

open (INFILE, "$infile") || die "$me: Can't open $infile: $!\n";
binmode(INFILE);
## Byte operations.
if ($opt{b} and (! $opt{p}) and (! $opt{l}) and (! $opt{"?"})) {

    my ($chunk, $fh);
    my $count = get_count ($opt{b});

    unless ($count) { die qq($me: "$opt{b}" is invalid number of bytes.\n) }
    
    while (read (INFILE, $chunk, $count) == $count) {
	$fh = nextfile ($prefix);
	print $fh $chunk;
    }

    # leftover bit. Last file will be >= $count. 
    # There's gotta be something more elegant than this, too.
    if (length($chunk)) {
	$fh = nextfile ($prefix);
        print $fh $chunk;
    } 
}
   
## Split on patterns.
elsif ($opt{p} and (! $opt{b}) and (! $opt{l}) and (! $opt{"?"})) {

    my $regex = $opt{p};
    my $fh = nextfile ($prefix);

    while (<INFILE>) {
	$fh = nextfile ($prefix) if /$regex/;
	print $fh $_;
    }
}

## Line operations.
elsif ((! $opt{p}) and (! $opt{b}) and (! $opt{"?"})) {

    # default is -l 1000  (NOT 1k!)
    my $fh;
    my $count = (defined $opt{l} ? get_count($opt{l}) : 1000);
    my $line = 0;

    unless ($count) { die qq($me: "$opt{l}" is invalid number of lines.\n) }

    while (<INFILE>) {
	$fh = nextfile ($prefix) if $line % $count == 0;
	print $fh $_;
	$line++;
    }
 
}

else { clue };

# (Thanks to Abigail for the pod template.)

=pod

=head1 NAME

split - split a file into pieces

=head1 SYNOPSIS

split [C<-b> byte_count[k|m]] [C<-l> line_count] [C<-p> pattern] [file [name]]

=head1 DESCRIPTION 

The B<split> utility reads the given I<file> (or standard input if no file
is specified) and breaks it up into files of 1000 lines each.

=head1 OPTIONS

B<split> accepts the following options:

=over 4

=item -b byte_count[k|m]

Create smaller files I<byte_count> bytes in length.  If ``k'' is
appended to the number, the file is split into I<byte_count> kilobyte
pieces.  If ``m'' is appended to the number, the file is split into
I<byte_count> megabyte pieces.

=item -l line_count[k|m]

Create smaller files I<line_count> lines in length. ``k'' and ``m'' operate as 
with B<-b>.

=item -p pattern

The file is split whenever an input line matches I<pattern>, which is
interpreted as a Perl regular expression.  The matching line will be
the first line of the next output file.  This option is incompatible
with the B<-b> and B<-l> options.

=item -?

Short usage summary.

=back

If additional arguments are specified, the first is used as the name
of the input file which is to be split.  If a second additional
argument is specified, it is used as a I<prefix> for the names of the
files into which the file is split.  In this case, each file into
which the file is split is named by the I<prefix> followed by a
lexically ordered suffix in the range of ``aaa-zzz''.

If the name argument is not specified, the file is split into lexically
ordered files named in the range of ``xaaa-xzzz''.

=head1 BUGS

B<split> can only create 17576 files.

=head1 SEE ALSO
     

perlre(1)

=head1 AUTHOR

The Perl implementation of B<split> was written by Rich Lafferty,
I<rich@alcor.concordia.ca>.

=head1 COPYRIGHT and LICENSE

This program is free and open software. You may use, copy, modify,
distribute and sell this program (and any modified variants) in any
way you wish, provided you do not restrict others to do the same.

=cut


