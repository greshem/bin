#!/usr/bin/perl -w
# $Id: pom,v 1.2 2004/08/05 14:17:43 cwest Exp $

use strict;

{ my $vt100_compatible = 0;
  $vt100_compatible ||= $ENV{TERM}    =~ /vt100|xterm|ansi/i;
  $vt100_compatible ||= $ENV{TERMCAP} =~ /vt100|xterm|ansi/i;
  if ($^O eq 'VMS') {
    $vt100_compatible = grep(/VT\d{2,}/i, `SHOW TERMINAL $ENV{TT}`)
  }
  my $cursor_home  = $vt100_compatible ? "\e[0;0H" : ('-' x 78 . "\n");
  my $screen_clear = $vt100_compatible ? "\e[2J" : '';
  sub CURSOR_HOME  { $cursor_home }
  sub SCREEN_CLEAR { $screen_clear }
}

#
## Astronomical constants

sub EPOCH    () { 2444238.5    } # 1980 January 0.0
sub ELONGE   () { 278.833540   } # ecliptic longitude of the Sun at EPOCH
sub ELONGP   () { 282.596403   } # ecliptic longitude of the Sun at perigee
sub ECCENT   () {   0.01671542 } # Earth's orbit's eccentricity
sub MMLONG   () {  64.975464   } # moon's mean longitude at EPOCH
sub MMLONGP  () { 349.383063   } # mean longitude of the perigee at EPOCH
sub MLNODE   () { 151.950429   } # mean longitude of the node at EPOCH
sub SYNMONTH () {  29.53058868 } # synodic month (new Moon to new Moon)
sub PI       () { 3.141592654  } # assume uncurved space

#
## Helper functions

sub sign     { ($_[0]<0) ? -1 : (($_[0]>0) ? 1 : 0); }
sub floor    { my $x = int($_[0]); ($x<$_[0]) ? $x : $x-1; }
sub fmod     { $_[0] - (int($_[0] / $_[1]) * $_[1]); }
sub fixangle { fmod(($_[0] - (360 * (floor($_[0] / 360)))), 360); }
sub torad    { ($_[0] * (PI / 180)); }
sub todeg    { ($_[0] * (180 / PI)); }
sub FNITG    { (sign($_[0]) * floor(abs($_[0]))); }
sub tan      { sin($_[0]) / cos($_[0]); }
sub atan     { atan2($_[0], 1) }

#
## Parse the command line, filling in with the current GMT

my ($cc, $yy, $mm, $dd, $hh);
my ($gm_yy, $gm_mm, $gm_dd, $gm_hh) = (gmtime(time))[5,4,3,2];
$gm_yy += 1900; $gm_mm++;

my $debugging = 0;
my $enhanced_behavior = 0;

foreach my $switch (grep /^\-/, @ARGV) {
  $debugging = 1 if ($switch =~ /d/i);
  $enhanced_behavior = 1 if ($switch =~ /e/i);
}

if (grep /^\-e(nhanced)?$/i, @ARGV) {
  $enhanced_behavior = 1;
}
                                        # remove any -switches
@ARGV = grep !/^\-/, @ARGV;

if (@ARGV) {
  if ( (@ARGV != 1) ||
       (length($ARGV[0]) & 1) || !length($ARGV[0]) || (length($ARGV[0]) > 10)
  ) {
    die "$0 usage: $0 [-d] [-e] [[[[[[cc]yy]mm]dd]HH]]\n";
  }

  ($hh, $dd, $mm, $yy, $cc) = reverse($ARGV[0] =~ /(..)/g);

  defined($cc) || ($cc = substr($gm_yy,0,2));
  defined($yy) && ($yy = $cc . $yy);
}

defined($hh) || ($hh = $gm_hh);
defined($dd) || ($dd = $gm_dd);
defined($mm) || ($mm = $gm_mm);
defined($yy) || ($yy = $gm_yy);

die "$0: bad month $mm\n" if ($mm=~/\D/ || $mm<1 || $mm>12);
die "$0: bad day $dd\n"   if ($dd=~/\D/ || $dd<1 || $dd>31);
die "$0: bad hour $hh\n"  if ($hh=~/\D/ || $hh<0 || $hh>23);

#
## Convert phase time to Julian

sub mdy_to_julian {
  my ($mm, $dd, $yy) = @_;
  my ($j_a, $j_b, $j_c, $j_d);

  my $j_mm = $mm;
  my $j_yy = $yy;

  $j_yy++ if ($j_yy < 0);
  if ($j_mm < 3) {
    $j_mm += 12;
    $j_yy--;
  }
  if ( ($yy < 1582) ||
       ($yy == 1582 and $mm < 10) ||
       ($yy == 1582 and $mm == 10 and $dd < 15)
  ) {
    $j_b = 0;
  }
  else {
    $j_a = floor($j_yy / 100);
    $j_b = 2 - $j_a + floor($j_a / 4);
  }
  if ($j_yy >= 0) {
    $j_c = floor(365.25 * $j_yy) - 694025;
  }
  else {
    $j_c = FNITG((365.25 * $j_yy) - 0.75) - 694025;
  }
  $j_d = floor(30.6001 * ($j_mm + 1));

  $j_b + $j_c + $j_d + $dd + 2415020;
}

#
## Calculate the eccentric anomaly using Kepler's equation.

sub kepler {
  my ($m, $ecc) = @_;

  sub EPSILON { 1e-6 }

  my $e = $m = torad($m);

  my $delta;
  do {
    $delta = $e - $ecc * sin($e) - $m;
    $e -= $delta / (1 - $ecc * cos($e));
  } while (abs($delta) > EPSILON);

  $e;
}

#
## Calculate the phase of the moon as a fraction (0.0 -> 0.99).  New
## Moon is 0, First Quarter is 0.25, Full Moon is 0.5, Last Quarter is
## 0.75.

sub calc_phase {
  my ($hh, $mm, $dd, $yy) = @_;

  # $utc_offset is in fractions of a day.  For more accurate moon
  # phases, calculate this from the local timezone.

  my $utc_offset = 0;
  my $pdate = mdy_to_julian($mm, $dd, $yy) + ($hh/24) + $utc_offset; 

  # sun's position

  my $day = $pdate - EPOCH;
  my $sun_mean_anomaly = fixangle((360 / 365.2422) * $day);
  my $sun_epoch_coords = fixangle($sun_mean_anomaly + ELONGE - ELONGP);

  my $sun_ecc = kepler($sun_epoch_coords, ECCENT);
  $sun_ecc = sqrt((1 + ECCENT) / (1 - ECCENT)) * tan($sun_ecc / 2);
  $sun_ecc = 2 * todeg(atan($sun_ecc)); # true anomaly
                                        # sun's geocentric ecliptic longitude
  my $sun_lambda = fixangle($sun_ecc + ELONGP);

  # moon's position

  my $moon_mean_longitude = fixangle(13.1763966 * $day + MMLONG);
  my $moon_mean_anomaly =
    fixangle($moon_mean_longitude - 0.1114041 * $day - MMLONGP);
  my $moon_evection = 1.2739
    * sin(torad(2 * $moon_mean_longitude - $sun_lambda) - $moon_mean_anomaly);
  my $moon_annual_equation = 0.1858 * sin(torad($sun_epoch_coords));
  my $moon_correction_1 = 0.37 * sin(torad($sun_epoch_coords));
  my $moon_corrected_anomaly = $moon_mean_anomaly + $moon_evection -
    $moon_annual_equation - $moon_correction_1;
  my $moon_correction_for_center =
    6.2886 * sin(torad($moon_corrected_anomaly));
  my $moon_correction_2 = 0.214 * sin(torad(2 * $moon_corrected_anomaly));
  my $moon_corrected_longitude =
    $moon_mean_longitude + $moon_evection + $moon_correction_for_center
    - $moon_annual_equation - $moon_correction_2;
  my $moon_variation = 0.6583
    * sin(torad(2 * ($moon_corrected_longitude - $sun_lambda)));
  my $moon_true_longitude = $moon_corrected_longitude + $moon_variation;

  # age of moon, in degrees

  my $moon_age = $moon_true_longitude - $sun_lambda;

  # age of moon as a fraction of a circle

  fixangle($moon_age) / 360;
}

if ($debugging) {
  print "entered    = yy($yy)  mm($mm)  dd($dd)  hh($hh)\n";
  print "julian day = ", mdy_to_julian($mm, $dd, $yy), "\n";
  print "moon phase = ", calc_phase($hh, $mm, $dd, $yy), "\n";
}

#
## Draw the moon.

my $terminal_width  = (($ENV{COLS} || $ENV{COLUMNS} || 80) & ~1) - 2;
my $terminal_height = ($ENV{LINES} || $ENV{ROWS} || 25) - 3;
my $aspect_ratio = 5 / 7;
my @surface_char = (':', '-', '+', '=', '*', 'O', '0', '8', '#', '@');

sub display_moon {
  my ($mm, $dd, $yy, $hh) = @_;

  my $real_phase = calc_phase($hh, $mm, $dd, $yy);
  my $rotated_scaled_phase = ($real_phase * 360 - 180) / 180;
  $real_phase = sprintf('%.2f', $real_phase);
                                        # convert visible phase to percent of full
  my $phase_percent = int($rotated_scaled_phase * 100);
  $phase_percent = ( ($phase_percent < 0)
                     ? (100 + $phase_percent)
                     : (100 - $phase_percent)
                   );
                                        # convert phase percent to name
  my $phase_name;
  if ($phase_percent < 2) {
    $phase_name = 'New';
  }
  elsif ($phase_percent > 99) {
    $phase_name = 'Full';
  }
  elsif ($phase_percent == 50) {
    if ($real_phase < 0.5) {
      $phase_name = 'First Quarter';
    }
    else {
      $phase_name = 'Last Quarter';
    }
  }
  elsif ($phase_percent < 50) {
    if ($real_phase < 0.5) {
      $phase_name = 'Waxing Crescent';
    }
    else {
      $phase_name = 'Waning Crescent';
    }
  }
  else {
    if ($real_phase < 0.5) {
      $phase_name = 'Waxing Gibbous';
    }
    else {
      $phase_name = 'Waning Gibbous';
    }
  }
                                        # happyfun enhanced behavior
  if ($enhanced_behavior) {
    my $increment = 2 / $terminal_height;
    my $count = 0;
    for (my $y=1-($increment/2); $y>-1; $y -= $increment) {
      my $x = sqrt(1 - $y**2);

      my $moon_size  = int($x * $terminal_width * $aspect_ratio);
      ($moon_size & 1) && ($moon_size--); # symmetry fudge
      my $space_size = ($terminal_width - $moon_size) / 2;

      $count++;
      my $text = '';
      if ($count==1) {
        $text = "Date : $mm/$dd/$yy:$hh";
      }
      elsif ($count == 2) {
        $text = "Phase: $phase_name";
      }
      elsif ($count == 3) {
        $text = "Full : $phase_percent\%";
      }

      my $space = $text . (' ' x ($space_size - length($text)));

      my $dark_size          = $moon_size * abs($rotated_scaled_phase);
      my $light_size         = $moon_size - $dark_size;
      my $terminus_intensity = $light_size - int($light_size);

      my $dark_side  = $surface_char[0] x $dark_size;
      my $terminus   = $surface_char[$terminus_intensity * @surface_char];
      my $light_side = $surface_char[-1] x $light_size;

      print( $space, ( ($rotated_scaled_phase < 0) ?
                       ($dark_side . $terminus . $light_side) :
                       ($light_side . $terminus . $dark_side)
                     ),
             "\n"
           );
    }
  }
                                        # standard, boring behavior
  else {
    print "The Moon is $phase_name ($phase_percent\% of Full)\n";
  }
}

#
## If debugging, cycle through all the phases for the month.  Compare
## vs. <http://www.googol.com/moon/>.  Otherwise, just display the one
## date/time.

if ($debugging) {
  print SCREEN_CLEAR if ($enhanced_behavior);
  for ($dd = 1; $dd < 32; $dd++) {
    for ($hh = 0; $hh < 24; $hh++) {
      print CURSOR_HOME if ($enhanced_behavior);
      &display_moon($mm, $dd, $yy, $hh);
    }
  }
}
else {
  &display_moon($mm, $dd, $yy, $hh);
}

exit;

__END__

=head1 NAME

  pom - display the phase of the moon

=head1 SYNOPSIS

  pom [-d] [-e] [[[[[[cc]yy]mm]dd]HH]]

=head1 DESCRIPTION

The pom utility displays the current phase of the moon.  This is
useful for selecting software completion target dates, predicting
managerial behavior, or determining thoth's current mood. :)

Pom will display the current moon phase, unless a new time is
specified on the command line.  The parameter's format is similar to
the canonical representation used by date(1).

Pom has two modes: "standard" and "enhanced".  Standard mode presents
a brief description of the moon's phase.  It is the default.  Enhanced
mode shows the phase's date and time, the brief description, and an
ASCII art representation of the moon's phase.

Current options:

  -d    Enable debugging.  This calculates phase information every
        hour for a month.

  -e    Enable enhanced mode.  Turns on the ASCII art feature.

=head1 SEE ALSO

  date(1)

=head1 BUGS

Times must be within the range of the Unix epoch.

The local timezone and coordinates are not considered.

Day validation does not consider the current month, or leap days.

The default character cell aspect ratio is likely to be wrong.

There is some jitter in the current calculations.  It may only be
noticeable while debugging.

The calculations in this version are a few percent different from the
original pom.

=head1 ACKNOWLEDGEMENTS

A lot of the documentation was cribbed from the OpenBSD Reference
Manual.

The moon phase calculations were ported from pcal, which is available
from <ftp://www.decus.org/pub/lib/vs0174/pcal/>.

=head1 AUTHOR and COPYRIGHT

Pom is Copyright 1999 Rocco Caputo <troc@netrus.net>.  All rights
reserved.  Pom is free software; you may redistribute it and/or modify
it under the same terms as Perl itself.


