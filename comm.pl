#!/usr/bin/perl
#
# comm
#
# 1999 M-J. Dominus (mjd-perl-comm@plover.com)
# Public domain.
#
@COL[1,2,3] = (1,1,1);

if ($ARGV[0] =~ /^-[123]+$/) {
  $opt = shift;
  while ($opt =~ /[123]/g) {
    $COL[$&] = 0;
  }
}

unless (@ARGV == 2) {
  die "Usage: comm [-123] file1 file2\n";
}

open F1, "< $ARGV[0]"
  or die "comm: Couldn't open file $ARGV[0]: $!\n";
open F2, "< $ARGV[1]"
  or die "comm: Couldn't open file $ARGV[1]: $!\n";

$r1 = <F1>;
$r2 = <F2>;

while (defined $r1 && defined $r2) {
  if ($r1 eq $r2) {
    print "\t\t", $r1 if $COL[3];
    $r1 = <F1>;
    $r2 = <F2>;
  } elsif ($r1 gt $r2) {
    print "\t", $r2 if $COL[2];
    $r2 = <F2>;
  } else {
    print $r1 if $COL[1];
    $r1 = <F1>;
  }
}

print $r1 if defined $r1 && $COL[1];
print "\t", $r2 if defined $r2 && $COL[2];
if ($COL[1]) { print while <F1> }
if ($COL[2]) { print "\t", $_ while <F2> }
