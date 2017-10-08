#!/usr/bin/perl -w
# awk - front end for a2p 

use strict;

my(
    $program,		# the code to eval
    $tmpin, 		# the files a2p reads
    $tmpout, 		# the files a2p writes
    @nargs,		# new args for a2p
    @vargs		# temporary holder of variables
);

END {
    unlink $tmpin, $tmpout; # XXX: don't check failure
    close STDOUT 	    || die "$0: can't close stdout: $!\n";
    $? = 1 if $? == 255;    # from die
} 

sub usage {
    warn "$0: @_\n" if @_;
    die "usage: $0 [ -F fs ] [ [-v] var=value ] [ 'prog' | -f progfile ] [ file ...  ]\n";
} 

usage() unless @ARGV;

# the following dance is needed to avoid explicit 
# pipes or even redirections for process control 
# on broken soi-disant operating systems.

open(SAVE_OUT, ">&STDOUT") || die "can't save stdout: $!";
die unless defined fileno SAVE_OUT;

open(TMPIN, ">  " . ($tmpin = "a2pin.$$"))	     ||
open(TMPIN, ">  " . ($tmpin = "/tmp/a2pin.$$"))      ||
die "can't find a tmp input file";

open(TMPOUT,"+> " . ($tmpout = "a2pout.$$"))	     ||
open(TMPOUT,"+> " . ($tmpout = "/tmp/a2pout.$$"))    ||
die "can't find a tmp output file";

# And some people think getopts does everything. Sheesh.
while (@ARGV) {
    $_ = $ARGV[0];
    if (s/^-//) {
	if (s/^F//) {
	    unless (length) { shift; $_ = $ARGV[0]; } 
	    push(@nargs, "-F$_");
	    shift;
	    next;
	} 
	elsif (s/^v// || /^\w+=/) {
	    unless (length) { shift; $_ = $ARGV[0]; } 
	    push(@vargs, $_);
	    shift;
	    next;
	}
	elsif (s/^f//) {
	    unless (length) { shift; $_ = shift; } 
	    push(@nargs, $_);
	    last;
	} 
	elsif (s/^-//) {
	    if (length) { usage("Long options not supported") }
	    shift;
	    next;
	}
	else { 
	    usage("unknown flag: -$_");
	}
    } else { 
	# XXX: is it a program or an expression?  
        if (/^\w+=/) {
	    push(@vargs, $_);
	    shift;
	    next;
	}  
	else { 
	    print TMPIN "$_\n";
	    shift;
	    push @nargs, $tmpin; 
	    last;
	}
    }
} 

unshift @ARGV, @vargs;  # put back var=val statements

close(TMPIN)		    || die "can't close $tmpin: $!";

open(STDOUT, ">&TMPOUT")    || die "can't dup to $tmpout: $!";
$| = 1;

system 'a2p', @nargs;

if ($?) {
    die "Couldn't run a2p (wait status == $?)";
} 

die "empty program" unless -s TMPOUT;
die "empty program" unless -s $tmpout;

seek(TMPOUT, 0, 0)	   || die "can't rewind $tmpout: $!";
$program = do { local $/;  <TMPOUT> };   
close(TMPOUT)	   || die "can't close $tmpout: $!";
open(STDOUT, ">&SAVE_OUT") || die "can't restore stdout: $!";

eval qq{
    no strict; 
    local \$^W = 0;
    $program;
}; 

if ($@) {
    die "Couldn't compile and execute awk-to-perl program: $@\n";
} 

exit 0;

__END__

=head1 NAME

awk - pattern-directed scanning and processing language

=head1 SYNOPSIS

B<awk> 
[ B<-F> I<fs> ] 
[ [B<-v>] I<var>=I<value> ] 
[ I<'prog'> 
| 
B<-f>~ I<progfile> ]
[ I<file> ...  ]

=head1 DESCRIPTION

This version of the standard I<awk> utility is nothing more than a
wrapper that massages its arguments and calls the I<a2p> translator to
do the real conversion into Perl, which is then compiled and executed.

=head1 SEE ALSO

a2p(1)

A. V. Aho, B. W. Kernighan, P. J. Weinberger, I<The AWK Programming
Language>, Addison-Wesley, 1988. ISBN 0-201-07981-X

The One True Awk can be found at Brian Kernighan's 
http://cm.bell-labs.com/cm/cs/awkbook/index.html page.

=head1 RESTRICTIONS

I<a2p> does not attempt to translate the myriad splinter
versions of I<awk>, nor follow the arguments there to.

=head1 BUGS

This manpage should probably include the entire 
I<awk> manpage, and perhaps that of I<a2p> as well.

It is not clear that I<a2p> has tracked Brian's work 
in the last few years.

=head1 AUTHOR

This front-end written by Tom Christiansen, I<tchrist@perl.com>.
The I<a2p> translator was written by Larry Wall, I<larry@wall.org>,
author of Perl.

=head1 COPYRIGHT and LICENSE

This program is copyright (c) Tom Christiansen 1999.

This program is free and open software. You may use, modify, distribute,
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others from doing the same.
