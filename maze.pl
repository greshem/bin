#!/usr/bin/perl -w
# $Id: maze,v 1.2 2004/08/05 14:17:43 cwest Exp $

use strict;

sub R { 1 }
sub B { 2 }
sub L { 4 }
sub T { 8 }

my (@maze, @walk);

#
## Parse maze type options.

sub usage {
  die "$0 usage: $0 [-fl|-fi|-df|-sf] [width height]\n"
}

sub traverse_by_depth         { -1 }            # normal mazes (long walks)
sub traverse_by_breadth       { 0 }             # flood fills (short walks)
sub traverse_randomly         { rand(@walk) }   # fiendish mazez (random walks)
sub traverse_randomly_deep    {-rand(@walk/2) } # longer random walks
sub traverse_randomly_shallow { rand(@walk/2) } # shorter random walks

my $walk_function = \&traverse_by_depth;

foreach my $switch (grep /^\-/, @ARGV) {
  $walk_function = \&traverse_by_breadth       if ($switch =~ /^-fl/i);
  $walk_function = \&traverse_randomly         if ($switch =~ /^-fi/i);
  $walk_function = \&traverse_randomly_deep    if ($switch =~ /^-df/i);
  $walk_function = \&traverse_randomly_shallow if ($switch =~ /^-sf/i);
  &usage if ($switch !~ /^-(fl|fi|df|sf)$/i);
}

@ARGV = grep !/^\-/, @ARGV;
&usage if (@ARGV && (@ARGV != 2));

#
## Parse maze size options.  Fall back on standard behavior if the
## size isn't specified on the command line.

my ($width, $height);

($width, $height) = @ARGV if (@ARGV == 2);

sub get_number {
  my ($prompt, $value) = @_;

  while (!defined($value) or $value < 2) {
    (defined $value) and ($value < 2) and print "$prompt too small.\n";
    print "$prompt? ";
    chomp($value = <STDIN>);
  }

  $value;
}

$width  = &get_number('width',  $width);
$height = &get_number('height', $height);

my $test_width  = $width - 1;
my $test_height = $height - 1;

#
## initialize the maze

for (my $y=0; $y<$height; $y++) {
  push @maze, [ (0) x $width ];
}

my $in = int(rand($width));
push @walk, [0, $in];

#
## random walk the maze, knocking down walls
##
## <purl> Cross over the cell bars, find a new maze, make the maze
## from its path, find the cell bars, cross over the bars, find a
## maze, make the maze from its path, eat the food, eat the path.

while (@walk) {
  my $walk_index = &$walk_function();
  my ($y, $x) = @{$walk[$walk_index]};

  my @good_directions;
  push(@good_directions, [ T, B, $y-1, $x ])
    if ($y && !$maze[$y-1][$x]);
  push(@good_directions, [ B, T, $y+1, $x ])
    if (($y < $test_height) && !$maze[$y+1][$x]);
  push(@good_directions, [ L, R, $y, $x-1 ])
    if ($x && !$maze[$y][$x-1]);
  push(@good_directions, [ R, L, $y, $x+1 ])
    if (($x < $test_width) && !$maze[$y][$x+1]);

  unless (@good_directions) {
    splice(@walk, $walk_index, 1);
    next;
  }

  my ($direction, $complementary_direction, $next_y, $next_x) =
    @{$good_directions[rand @good_directions]};

  $maze[$y][$x] |= $direction;
  $maze[$next_y][$next_x] |= $complementary_direction;

  splice(@walk, $walk_index, 1) if (@good_directions == 1);
  push @walk, [ $next_y, $next_x ];
}

#
## display the maze
#

my @cellbits = ( [ '', '   ', '  +', '', '|', '', '', '', '  +' ],
                 [ '', '  |', '--+', '', '|', '', '', '', '--+' ],
               );
my @wallbits = ( '', '|', '+' );

#
## input at top
#

print "+";
for (my $x=0; $x<$width; $x++) {
  print $cellbits[$x!=$in]->[T];
}
print "\n";

#
## output at bottom of maze
#

$maze[-1]->[rand($width)] |= B;

#
## maze itself
#

foreach my $row (@maze) {
  foreach my $wall (R, B) {
    print $wallbits[$wall];
    foreach my $cell (@$row) {
      print $cellbits[!($cell & $wall)]->[$wall];
    }
    print "\n";
  }
}

__END__

=head1 NAME

maze - generate a maze problem

=head1 SYNOPSIS

  maze [ -fl | -fi | -df | -sf ] [width height]

=head1 DESCRIPTION

Without arguments, maze defaults to the standard behavior.  It asks
for the desired width and height, then displays a maze on standard
output.

Maze contains five maze types: the normal one (no option), flood fills
(-fl), fiendish random mazes (-fi), fiendish favoring longer paths
("deep" fiendish: -df), and fiendish favoring shorter paths ("shallow"
fiendish: -sf).

Maze also accepts the width and height on the command line.  If either
is too small, it will prompt for a replacement.

=head1 BUGS

Large mazes are slow.

=head1 AUTHOR and COPYRIGHT

Maze is Copyright 1999 Rocco Caputo <troc@netrus.net>.  All rights
reserved.  Maze is free software; you may redistribute it and/or
modify it under the same terms as Perl itself.


