#!/usr/bin/perl -w

# $Id: pwd,v 1.2 2004/08/05 14:17:43 cwest Exp $
#
# $Log: pwd,v $
# Revision 1.2  2004/08/05 14:17:43  cwest
# cleanup, new version number on website
#
# Revision 1.1  2004/07/23 20:10:15  cwest
# initial import
#
# Revision 1.0  1999/03/04 15:19:03  meltzek
# Initial revision
#


use strict;
use Cwd;
use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);

print "g_pwd=".$g_pwd."\n";;
print "g_basename=".$g_basename."\n";
print "g_dirname=".$g_dirname."\n";



my ($VERSION) = '$Revision: 1.2 $' =~ /([.\d]+)/;

my $dir;

# Account for / and \ on Win32 and non-Win32 systems
($^O=~/Win32/) ? ($dir = getcwd) =~s/\//\\/g : ($dir=getcwd);

print $dir . "\n";

exit;

__END__

=pod

=head1 NAME

pwd - working directory name

=head1 SYNOPSIS

pwd

=head1 DESCRIPTION

Pwd prints the pathname of the working (current) directory.

=head2 OPTIONS

I<pwd> takes no options.

=head1 ENVIRONMENT

The working of I<pwd> is not influenced by any environment variables. 

=head1 BUGS

I<pwd> has no known bugs.

=head1 REVISION HISTORY

    $Log: pwd,v $
    Revision 1.2  2004/08/05 14:17:43  cwest
    cleanup, new version number on website

    Revision 1.1  2004/07/23 20:10:15  cwest
    initial import

    Revision 1.0  1999/03/04 15:19:03  meltzek
    Initial revision




=head1 AUTHOR

The Perl implementation of I<pwd>
was written by Kevin Meltzer, I<perlguy@perlguy.com>.

=head1 COPYRIGHT and LICENSE

This program is copyright by Kevin Meltzer 1999.

This program is free and open software. You may use, modify, distribute
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others to do the same.

=cut


