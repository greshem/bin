#!/usr/bin/perl -w
use strict;
### no need to edit next line. Set by CS-RCS... http://www.componentsoftware.com/csrcs/uhome.htm
#REV='@(#)$RCSfile: what,v $ $Revision: 1.2 $ $Date: 2004/08/05 14:17:44 $';

sub printWhat($$$);

my $stop = 0;
if (($#ARGV >= 0) && ($ARGV[0] eq '-s'))
{
    $stop = 1;
    shift;
}

my $file = "";
if ($#ARGV < 0) ## use stdin
{
    printWhat(\*STDIN,$file,$stop);
}
else
{
    foreach $file (@ARGV)
    {
        open(FILE, "<$file") or die "Unable to read $file: $!";
        printWhat(\*FILE,$file,$stop);
        close FILE;
    }
}

#### read open file and print "what" statements...
#### pass in file handle, file name, and whether to stop printing after 1st "what"
sub printWhat($$$)
{
    my $file_handle = $_[0];
    my $file_name   = $_[1];
    my $stop_flag   = $_[2];
    print "$file_name:\n" if $file_name ne "";
    my $done = 0;
    while (! $done)
    {
        my $line = <$file_handle>;
        if (defined $line)
        {
            if ($line =~ /\@\(#\)/)
            {
                if ((! $stop_flag) && ($line =~ /\0/)) ## there may be more than 1 in here
                {
                    my @F = split(/\0/,$line);
                    my $f;
                    foreach $f (@F)
                    {
                        last if $done;
                        if ($f =~ /\@\(#\)/)
                        {
                            $f =~ s|.*\@\(#\)||;
                            $f =~ s|[">\0\\].*||; ##BSD spec says print to 1st " > \ or null
                            chomp $f;
                            print "        $f\n";
                            $done = 1 if $stop_flag;
                        }
                    }
                }
                else
                {
                    $line =~ s|.*\@\(#\)||;
                    $line =~ s|[">\0\\].*||; ##BSD spec says print to 1st " > \ or null
                    chomp $line;
                    print "        $line\n";
                }
                $done = 1 if $stop_flag;
            }
        }
        else { $done = 1; }
    }
}

exit;

__END__

=pod

=head1 NAME

what - extract version information from a file

=head1 SYNOPSIS

what [ C<-s> ] filename ...

=head1 DESCRIPTION

what searches each filename for occurrences of the pattern
B<@>(#) that the SCCS get command substitutes for the %Z% ID
keyword, and prints what follows up to a ", >, NEWLINE,
\, or null character. What can be used on any type of file,
NOT just SCCS files. Just put the magic 4 character B<@>(#) 
pattern in your file and you are set.

=head2 OPTIONS

B<->B<s> Stop after the first occurrence of the pattern.

=head1 ENVIRONMENT

The working of B<what> is not influenced by any environment variables.

=head1 EXAMPLES

If a Perl program test1.pl contains:

  my $REV = '@(# ) $Revision: 1.3 ...

and a C program test2.c contains:

  char rcsid[] = "@(# ) $Revision: 1.15 ....

and the C program is compiled to a.out...

The command:

prompt%> what test1.pl test2.c a.out

produces:

B<test1.pl:>
        B<$Revision>B<: 1.3 $';>

B<test2.c:>
        B<$Revision>B<: 1.15 $";>

B<a.out;>
        B<$Revision>B<: 1.15 $>

=head1 BUGS

B<what> has no known bugs.

=head1 REVISION HISTORY

$Log: what,v $
Revision 1.2  2004/08/05 14:17:44  cwest
cleanup, new version number on website

Revision 1.1  2004/07/23 20:10:21  cwest
initial import
 Revision 1.2 1999/03/28 06:28:47 schumacks Handles binary files better 

Revision 1.1 1999/03/23 10:57:39 schumacks Initial revision 

$Revision: 1.2 $ 

=head1 AUTHOR

This Perl implementation of B<what> was written by Ken Schumack schumacks@att.net

=head1 COPYRIGHT and LICENSE

This program is copyright by Ken Schumack 1999.

This program is free and open software. You may use, modify, distribute
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others from doing the same.

=cut


