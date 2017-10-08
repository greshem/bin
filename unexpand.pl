#!/usr/bin/perl -w

#
# A Perl implementation of expand(1) and unexpand(1) for the Perl Power
# Tools project by Thierry Bezecourt <thbzcrt@worldnet.fr>.
#
# I don't use Text::Tabs, because :
# - it cannot be used to implement the -a option
# - it doesn't recognize backspace characters
#
# Please see the pod documentation at the end of this file.
#
# 99/03/10 : first version
#

use strict;

my $tabstop = 8;
my $opt_a = 0;
my @tabstops;
my @files;

sub usage($;$)
{
    print <<"EOF";
Usage:
unexpand [-h] [-a] [-tabstop] [-tab1, tab2, ...] [file ...]  
EOF
    print STDERR $_[1] if $_[1];
    exit $_[0];
}

usage(1) unless scalar @ARGV > 0;
usage(0) if grep {$_ eq "-h"} @ARGV;

my $arg;
while($arg = shift @ARGV) {
    $opt_a = 1, next if $arg eq "-a";
    if($arg =~ /^-(.*)/) {
	@tabstops = split(/,/, $1);
	usage(1) if grep /\D/, @tabstops;
	next;
    }
    push @files, $arg;
}

usage(1) unless scalar @files >= 0;

# $tabstop is used only if multiple tab stops have not been defined
$tabstop = $tabstops[0] if scalar @tabstops == 1;

sub is_tab($)
{
    return (grep {$_ eq $_[0]} @tabstops) if scalar @tabstops >= 2;
    return ($_[0] % $tabstop == 0);
}

sub do_unexpand(@)
{
    for my $line(@_) {

	my $cumul = "";
	my $curs = 0;
	my @a = split //, $line;
	my $c;
	while($c = shift @a) {

	    if(is_tab($curs)) {
		if($cumul =~ /^(.*?)  +$/) {
		    print "$1\t";
		} else {
		    print $cumul;
		}
		$cumul = "";
	    }

	    # Print everything after the first non-space character,
	    # unless we use the -a option
	    $cumul .= $c.join("", @a), last
		if !$opt_a and $c ne " " and $curs > 0;

	    # Increment the cursor unless the character is a backspace.
	    if($c eq "\010") {
		$curs-- if $curs > 0;
	    } else {
		$curs++;
	    }

	    $cumul .= $c;
	}
	print $cumul;
    }
}

for my $file (@files) {
    open IN, $file or usage(1, "couldn't open '$file' for reading: $!'");

    do_unexpand <IN>;

    close IN;
}

__END__

expand, unexpand - expand tabs to spaces, and vice versa

=head1 SYNOPSIS

expand [B<-h>] [B<-tabstop>] [B<-tab1, tab2, ...>] [B<file> ...]

unexpand [B<-h>] [B<-a>] [B<-tabstop>] [B<-tab1, tab2, ...>]
[B<file> ...]

=head1 DESCRIPTION

I<expand> processes the named files or the standard input writing the
standard output with tabs changed into blanks.  Backspace characters
are preserved into the output and decrement the column count for tab
calculations.  I<expand> is useful for pre-processing character files
(before sorting, looking at specific columns, etc.) that contain tabs.

If a single B<tabstop> argument is given, tabs are set B<tabstop> spaces
apart instead of the default 8.  If multiple tabstops are given then
the tabs are set at those specific columns.

I<unexpand> puts tabs back into the data from the standard input or the
named files and writes the result on the standard output.

Option (with I<expand> and I<unexpand>):

=over 4

=item -h

Print a usage message and exit with a status code indicating success.

=back

Option (with I<unexpand> only):

=over 4

=item -a

By default, only leading blanks and tabs are reconverted to maximal
strings of tabs.  If the B<-a> option is given, tabs are inserted
whenever they would compress the resultant file by replacing two or
more characters.

=back

=head1 AUTHOR

=for html 
The Perl implementation was written by <A
href="mailto:thbzcrt@worldnet.fr">Thierry B&eacute;zecourt</A> for the
<A href="http://language.perl.com/ppt/">Perl Power Tools project</A>,
March 1999.

=for html <!--

The Perl implementation was written by Thierry Bezecourt,
I<thbzcrt@worldnet.fr>.  Perl Power Tools project, March 1999.

=for html -->

This documentation comes from the BSD expand(1) man page.

=head1 COPYRIGHT and LICENSE

This program is free and open software. You may use, modify, distribute,
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others from doing the same.

=cut

