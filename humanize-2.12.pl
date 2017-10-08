#!/usr/bin/perl -w
#
# $Id: humanize,v 2.12 2003/08/01 02:10:56 jmates Exp $
#
# The author disclaims all copyrights and releases this script into the
# public domain.
#
# Run perldoc(1) on this file for additional documentation.
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

######################################################################
#
# VARIABLES

my $VERSION;
($VERSION = '$Revision: 2.12 $ ') =~ s/[^0-9.]//g;

my (%opts, $base, $regex);

# default to working on runs of 4 or more digits
$regex = '(-?\d{4,})';

######################################################################
#
# MAIN

# parse command-line options
getopts('h?kb:m:r', \%opts);

help() if exists $opts{'h'} or exists $opts{'?'};

# set the base conversion factor
if (exists $opts{'b'}) {
  ($base) = $opts{'b'} =~ m/(\d+)/;
  die "Error: base should be a positive integer\n" unless $base;
}

$base = 1024 if exists $opts{'k'};

# set different regex if requried, add matching parens if none
# detected in input, as we need to match *something*
$regex = $opts{'m'} if exists $opts{'m'};
$regex = '(' . $regex . ')' unless $regex =~ m/\(.+\)/;

@ARGV = <STDIN> unless @ARGV;

for (@ARGV) {
  if (exists $opts{'r'}) {
    while (m/$regex/go) {
      my $orig = $1;
      my $human = humanize($orig, {base => $base});
      s/$regex/' 'x(length($orig) - length($human)).$human/eo;
    }
  } else {
    s/$regex/humanize($1, {base => $base})/ego;
  }
  $_ .= "\n" unless m/\n$/;
  print;
}

exit;

######################################################################
#
# SUBROUTINES

# Inspired from GNU's df -h output, which fixes 133456345 bytes
# to be something human readable.
#
# takes a number, returns formatted string.  Optionally accepts
# hash reference containing non-standard defaults.
sub humanize {
  my $num   = shift;
  my $prefs = shift;

  # error checking on input...
  return $num unless $num =~ m/^-?\d+$/;

  # various parameters that adjust how the humanization is done
  # these really should be able to be specified on the command line, or
  # read in from a prefs file somewhere, as nobody will agree as to what
  # "proper" human output should look like... :)
  my %defaults = (

    # base numbers are in (1 is bytes, 1024 for K)
    'base' => 1,

    # include decimals in output? (e.g. 25.8K vs. 26K)
    'decimal' => 1,

    # include .0 in decmail output?
    'decimal_zero' => 1,

    # what to divide file sizes down by
    # 1024 is generally "Kilobytes," while 1000 is
    # "kilobytes," technically
    'factor' => 1024,

    # percentage above which will be bumped up
    # (e.g. 999 bytes -> 1 K as within 5% of 1024)
    # set to undef to turn off
    'fudge' => 0.96,

    # lengths above which decimals will not be included
    # for better readability
    'max_human_length' => 2,

    # list of suffixes for human readable output
    'suffix' => ['B', 'K', 'M', 'G', 'T', 'P', 'E', 'Z', 'Y'],
  );

  # merge passed options with defaults
  while (my ($k, $v) = each %$prefs) {
    if (exists $defaults{$k} and $v) {
      $defaults{$k} = $v;
    }
  }

  # some local working variables
  my $count  = 0;
  my $prefix = '';
  my $tmp    = '';

  # handle negatives
  if ($num < 0) {
    $num    = abs $num;
    $prefix = '-';
  }

  # adjust number to proper base
  $num *= $defaults{'base'};

  # reduce number to something readable by factor specified
  while ($num > $defaults{'factor'}) {
    $num /= $defaults{'factor'};
    $count++;
  }

  # optionally fudge "near" values up to next higher level
  if ($defaults{'fudge'}) {
    if ($num > ($defaults{'fudge'} * $defaults{'factor'})) {
      $count++;
      $num /= $defaults{'factor'};
    }
  }

  # no .[1-9] decimal on longer numbers for easier reading
  # only show decimal if format say so
  if (length sprintf("%.f", $num) > $defaults{'max_human_length'}
    || !$defaults{'decimal'}) {

    $tmp = sprintf("%.0f", $num);

    } else {
    $tmp = sprintf("%.1f", $num);

    # optionally hack trailing .0
    $tmp =~ s/\.0$// unless $defaults{'decimal_zero'};
  }

  return $prefix . $tmp . $defaults{'suffix'}->[$count];
}

# a generic help blarb
sub help {
  print <<"HELP";
Usage: $0 [options] [values]

Script to humanize numbers in data.

Options for version $VERSION:
  -h/-?  Display this message

  -b nn  Integer to offset incoming data by.
  -k     Default incoming data to Kilobtyes.  Default: bytes.

  -m rr  Regex to match what to operate on.  Default: $regex.
  -r     Align humanized numbers to right.  Default: left.

Run perldoc(1) on this script for additional documentation.

HELP
  exit;
}

######################################################################
#
# DOCUMENTATION

=head1 NAME

humanize - humanizes file sizes in data

=head1 SYNOPSIS

Make df(1) output readable on systems lacking the human output option:

  $ df -k | humanize -rk

Figure out what 3655004 is in bytes:

  $ humanize 3655004

=head1 DESCRIPTION

Intended as a quick way to humanize the output from random programs
that displays unreadable file sizes, such as df(1) on large file
systems:

  $ df -k | grep nfs
  nfs:/mbt    1026892400 704296472 322595928    69%    /mbt

While certain utilities now support humanized output internally, not
all systems have those utilities.  Hence, this perl script is intended
to fill that gap util more utilities support humanization routines
directly.  This will become more important as file systems continue to
grow, and the exact number of bytes something takes up less meaningful
to the user.

The data munged by this script is less accurate, in that rounding is
done in an effort to make the numbers more readable by a human.  In
the above case, the munged data would look like:

  $ df -k | grep nfs | humanize -k
  nfs:/mbt    1.0T 672G 308G    69%    /mbt

=head2 Normal Usage

  $ humanize [options] [values]

See L<"OPTIONS"> for details on the command line switches supported.

Data to be humanized may either be specified on the command line, or
piped in via standard input.

=head1 OPTIONS

This script currently supports the following command line switches:

=over 4

=item B<-h>, B<-?>

Prints a brief usage note about the script.

=item B<-b> I<base>

Optional integer to factor the incoming data by.  The humanizing
routine operates on bytes by default, so numbers of different formats
will have to be adjusted accordingly.

The value should be one that adjusts the incoming data to be in bytes
format; for example, incoming data in Kilobytes would need a base of
1024 to be converted properly to bytes, as there are 1024 bytes in
each Kilobyte.

=item B<-k>

Overrides B<-b> and treats the incoming data as if in Kilobytes.

=item B<-m> I<regex>

Optional perl regex to specify what in the incoming data should be
operated on; the default of digit runs of four or more characters
should be reasonable in most cases.

Your regex should match integers of some kind; otherwise, the script
will generally do nothing with your data and not print any warnings.
If you are matching numbers inside of a more complictated regex, you
will need to put parentheses around the number you want changed, and
use non-capturing parentheses for preceeding items, as only $1 is
passed to the humanizing routine.  See perlre(1) for more details.

If you leave parentheses out of your regex, they will be added around
it by default.  This lets you supply regex like '\d{7,}' and have it
work, which is the same as saying '(\d{7,})' in this case.

=item B<-r>

Align humanized numbers to the right by padding them with spaces.  Good
to preserve columns from utilities such as df(1).

=back

=head1 BUGS

=head2 Reporting Bugs

Newer versions of this script may be available from:

http://sial.org/code/perl/

If the bug is in the latest version, send a report to the author.
Patches that fix problems or add new features are welcome.

=head2 Known Issues

No known issues.

=head1 TODO

Option to read humanizing prefs from a external location would be a
nice idea.

=head1 SEE ALSO

perl(1)

=head1 AUTHOR

Jeremy Mates, http://sial.org/contact/

=head1 COPYRIGHT

The author disclaims all copyrights and releases this script into the
public domain.

=head1 HISTORY

Inspired from the B<-h> option present in GNU df, which is sorely
lacking in commercial varients of the same name.  (On the other hand,
leaving the job of humanizing to an external script is probably more
inline with the unix philosphopy of filters.)

=head1 VERSION

  $Id: humanize,v 2.12 2003/08/01 02:10:56 jmates Exp $

=head1 SCRIPT CATEGORIES

Utilities

=cut
