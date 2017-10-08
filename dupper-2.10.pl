#!/usr/bin/perl
#
# $Id: dupper,v 2.10 2003/08/01 02:10:56 jmates Exp $
#
# The author disclaims all copyrights and releases this script into the
# public domain.
#
######################################################################
#
# REQUIREMENTS

require 5;

use strict;

######################################################################
#
# MODULES

use Carp;         # better error reporting
use Getopt::Std;  # command line option processing

use Digest::SHA1;
use File::Spec;

######################################################################
#
# VARIABLES

my $VERSION;
($VERSION = '$Revision: 2.10 $ ') =~ s/[^0-9.]//g;

my (%opts, $verbose, $quiet, %check);

# we reset this for each file to avoid OO overhead on each file
my $dig = Digest::SHA1->new;

######################################################################
#
# MAIN

# parse command-line options
getopts('h?vlgzuqp:s:', \%opts);

help() if exists($opts{'h'}) or exists($opts{'?'});

$verbose = 1 if exists $opts{'v'};
if (exists $opts{'q'}) {
  $verbose = 0;
  $quiet   = 1;
}

# read from STDIN if no args left
chomp(@ARGV = <STDIN>) unless @ARGV;

# and flag the help text if nothing from STDIN
help() unless @ARGV;

# loop over arguments which presumably are a bunch of directories
for (@ARGV) {
  unless (-d) {
    warn 'Error: ', $_, " is not a directory.  Skipping.\n" unless $quiet;
    next;
  }
  parsedir($_);

  # reset the %check hash between directories by default
  unless (exists $opts{'g'} || exists $opts{'z'}) {
    report(\%check, $_);
    %check = ();
  }
}

report(\%check, 'all');

exit;

######################################################################
#
# SUBROUTINES

sub parsedir {
  my $dir = shift;

  my @to_parse;  # subdirs we may need to recurse into later

  # -z option allows checks to become single-directory
  # specific, as opposed to the parent-dir globalness of default
  # or the everywhere -g option
  %check = () if exists $opts{'z'};

  unless (opendir DIR, $dir) {
    warn 'Problem reading ', $dir, ': ', $!, "\n" unless $quiet;
    return;
  }

  # loop over sorted contents of directory, skipping . and .. specials
  for (sort readdir DIR) {
    next if /^\.{1,2}$/;
    my $pti = File::Spec->catfile($dir, $_);

    next if -l $pti;  # skip links. Links bad. :)

    # only deal with files when doing sums
    if (-f $pti) {

      # first check whether we skip this file
      if (exists $opts{'s'}) {
        my $result = eval "return 1 if( " . $opts{'s'} . " );";

        if ($@) {
          chomp($@);
          die "Skip error: ", $@;  # croak on errors
        }

        if ($result) {
          warn "Skipped ", $pti, "\n" if $verbose;
          next;
        }
      }

      # open up file, then hand it off to MD5 module
      unless (open FILE, $pti) {
        warn 'Problem reading ', $pti, ': ', $!, "\n";
        next;
      }
      binmode FILE;

      # reset checksum object, then get new Checksum on file
      $dig->new();
      $dig->addfile(*FILE);
      my $sum = $dig->hexdigest;

      close FILE;

      # either add new checksum to hash, or delete the duplicate file
      if (exists $check{$sum} && exists $opts{'u'}) {

        # show unlink statement, plus the file this one is dup'ing
        warn "unlink ", $pti, "\t(", $check{$sum}->[0], ")\n"
         if $verbose;
        unless (unlink $pti) {
          warn 'Problem unlinking ', $pti, ' (dup ', $check{$sum}->[0], '): ',
           $!, "\n";
        }
      }

      # regardless, we add the file to the list of files
      # associated with this particular hash
      push @{$check{$sum}}, $pti;

    } elsif (-d $pti) {

      # see whether this dir needs to be pruned from the search
      if (exists $opts{'p'}) {
        my $results = eval "return 1 if( " . $opts{'p'} . " );";

        if ($@) {
          chomp($@);
          die "Prune error: ", $@;  # croak on errors
        }

        if ($results) {
          warn "Pruned $pti\n" if $verbose;
          next;
        }
      }
      push @to_parse, $pti unless exists $opts{'l'};
    }
  }

  # print a report if we're doing the local-dir-only thing
  report(\%check, $dir) if exists $opts{'z'};

  # before poping up a recursion level, deal with subdirs
  unless (exists $opts{'l'}) {
    for (@to_parse) {
      parsedir($_);
    }
  }
}

# takes a hash reference (presumably to %check) and
# dumps out a little report of duplicate files
sub report {
  my $ref = shift;
  my $dir = shift;

  # quit out early if no-yak mode turned on
  return if exists $opts{'q'};

  # rummage through hash, printing out only hash entries
  # that have more than 1 file associated with them
  for (keys %$ref) {
    if (scalar @{$ref->{$_}} > 1) {
      print $dir, "\t", join (', ', @{$ref->{$_}}), "\n";
    }
  }
}

# a generic help blarb
sub help {
  print <<"HELP";
Usage: $0 [opts] [dir1 dir2 .. dirN]

Removes duplicate files based on checksum comparison of files.

Options for version $VERSION:
  -h/-?  Display this message
  -v     Verbose mode, a little bit more chatty.
  -q     Quiet.  Overrides -v, suppresses reporting.

  -u     Attempt to unlink any duplicates found past first.

  -l     Local mode only, script does not recurse into subdirs.

  -g     Make checksums apply across all directories on command line.
  -z     Overrides g; limits scope of checksums to only other files in
         the same directory.

  -s xx  Perl expression that will result in the current file (stored in \$_)
         being skipped if the expression turns out to be true.

  -p xx  Perl expression that will result in the current directory (stored in 
         \$_) being pruned out of the tree.

Run perldoc(1) on this script for additional documentation.

HELP
  exit;
}

######################################################################
#
# DOCUMENTATION

=head1 NAME

dupper - finds duplicate files, optionally removes them

=head1 SYNOPSIS

To get a list of duplicate files in a particular directory:

  $ dupper ~/public_html/images

=head1 DESCRIPTION

=head2 Overview

Script to find (and optionally remove) duplicate files in one or more
directories.  Duplicates are spotted though the use of MD5 checksums.

=head2 Normal Usage

  $ dupper [options] [dir1 dir2 .. dirN]

See L<"OPTIONS"> for details on the command line switches supported.

A list of directories to operate on should be specified on the command
line.  Failing that, the script will attempt to read directories from
STDIN.

=head1 OPTIONS

This script currently supports the following command line switches:

=over 4

=item B<-h>, B<-?>

Prints a brief usage note about the script.

=item B<-v>

Verbose mode, a little bit more chatty.

=item B<-q>

Quiet mode, overrides verbose mode, turns off reporting.

=item B<-u>

Attempt to unlink any duplicates past the first.  Default is just to
report the duplicate files.  Files are added least-depth first by
order of sort().  In other words, be sure you are deleting the right
thing.

=item B<-l>

Local-only mode; script will not recurse into subdirectories of any
directories passed to the script.

=item B<-g>

Make checksums apply across all directories on the command line.
Default is to treat the various directories supplied to the program as
their own separate realms.

=item B<-z>

Overrides B<-g>.  Limits the scope of checksums to only other files in
the exact same local directory as one another.  Much tighter than the
default scope.

=item B<-s> I<expression>

Perl expression that will result in the current file (stored in $_)
being skipped if the expression turns out to be "true."  Example:

  -s 'm/^\\.rsrc\$/ || -z \$pti || -s \$pti > 1048576'

Would skip the checksum on files named '.rsrc', or files that are
empty via the B<-z> is-empty test, or files larger than a megabyte.

=item B<-p> I<expression>

Perl expression that will result in the current directory (stored in
$_) being pruned out of the tree.  Like config dirs, for example:

  -p 'm/etc/'

Both B<-s> and B<-p> have access to the filename in $_, and can find
the full filepath in the variable $pti.  (Short for "path to item" in
case you were wondering.)

=back

=head1 EXAMPLES

To remove duplicate files under a web area via cron, skipping html
documents, matching only in local directories, and being very quiet:

  21 6 * * * dupper -uqzs 'm/\.html$/' /www/example/images

=head1 BUGS

=head2 Reporting Bugs

Newer versions of this script may be available from:

http://sial.org/code/perl/

If the bug is in the latest version, send a report to the author.
Patches that fix problems or add new features are welcome.

=head2 Known Issues

Large files will stall the checksum generation.  Have to spend a bit
of time and rewrite the checksum thingy to do files in chunks
properly.

=head1 TODO

Change out the hackish manual directory recurser with
L<File::Find|File::Find>.

=head1 SEE ALSO

perl(1)

=head1 AUTHOR

Jeremy Mates, http://sial.org/contact/

=head1 COPYRIGHT

The author disclaims all copyrights and releases this script into the
public domain.

=head1 VERSION

  $Id: dupper,v 2.10 2003/08/01 02:10:56 jmates Exp $

=head1 SCRIPT CATEGORIES

Utilities

=cut

