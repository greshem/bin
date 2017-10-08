#!/usr/bin/perl -w
# 
# Perl code is Copyright (c) 1995, 1999 Albert Dvornik <bert@mit.edu>
#
# Hexagram text is Copyright (c) 1988 The Regents of the University of
# California.  [Please see below for more information!]

use strict;

=head1 NAME

ching - the Book of Changes

=head1 SYNOPSIS

B<ching> [B<-n>] [B<-r>] [B<-h>] [B<-p> I<program>] [I<hexagram-lines>]

=cut

## usage 

sub usage { die "usage:  ching [-nrh] [-p pager] [hexagram-number]\n"; }

=head1 DESCRIPTION

The I<I Ching> or I<Book of Changes> is an ancient Chinese oracle that
has been in use for centuries as a source of wisdom and advice.

The text of the I<oracle> (as it is sometimes known) consists of
sixty-four I<hexagrams>, each symbolized by a particular arrangement
of six straight (---) and broken (S<- ->) lines.

Each hexagram consists of two major sections.  The B<Judgement>
relates specifically to the matter at hand (For instance, "It furthers
one to have somewhere to go.") while the B<Image> describes the
general attributes of the hexagram and how they apply to one's own
life ("Thus the superior man makes himself strong and untiring.").

=head2 The Lines

The lines are associated with numeric values ranging from six through
nine.  The even values (6 and 8) indicate broken lines, while the odd
values (7 and 9) indicate solid lines.

When the value is six or nine, the line is said to be I<moving>; for
any such line there is an appended judgement which becomes
significant.  Furthermore, the moving lines are inherently unstable
and change into their opposites; a second hexagram (and thus an
additional judgement) is formed.

The numeric value of a hexagram is constructed by listing the digits
corresponding to each of the lines, going from the bottom upward.

=cut

## These are the traditional numeric values for the lines:
# 6 --- "old yin":    broken (yin) moving to solid (yang)
# 7 --- "young yang": solid (yang)
# 8 --- "young yin":  broken (yin)
# 9 --- "old yang":   solid (yang) moving to broken (yin)

use vars qw( @hex_lines %hexagram );

## Traditional ordering of the hexagrams
@hex_lines = qw( 777777 888888 788878 878887 777878 878777 878888 888878
                 777877 778777 777888 888777 787777 777787 887888 888788
                 788778 877887 778888 888877 788787 787887 888887 788888
                 788777 777887 788887 877778 878878 787787 887778 877788
                 887777 777788 888787 787888 787877 778787 887878 878788
                 778887 788877 777778 877777 888778 877888 878778 877878
                 787778 877787 788788 887887 887877 778788 787788 887787
                 877877 778778 878877 778878 778877 887788 787878 878787 );

## Get hexagram number given its lines
%hexagram = map( ($hex_lines[$_], $_+1), 0..$#hex_lines );

## hexagram generation code

=head2 Consulting the Oracle

Normally, one consults the oracle by fixing the desired question
firmly in mind and then casting a set of changes (lines) using
yarrow-stalks or tossed coins.  The resulting hexagram will be the
answer to the question.

This oracle simply reads a question from the standard input (up to an
C<EOF>, or a period on a line by itself) and hashes the individual
characters in combination with the time of day, process ID and the
user's user and group IDs.  The resulting value is used as the seed of
a random number generator which drives a simulated coin-toss
divination.  The answer is then formatted and written to the standard
output.

=cut

# Read the question and hash it by adding all the characters together.
# Then get a set of six lines making up a change (pair of hexagrams).
sub ask_and_toss {
  my $question = 0;

  print STDERR "Type your question now.  ",
               "End with control-D or a dot on a line by itself.\n"
    if -t STDIN;

 LINE:
  while (<STDIN>) {
    last LINE if /^\.$/;
    $question += unpack('%8C*', $_);
  }

  srand(time + (31 * $question) + $< + $( + $$);

  # There are two traditional methods of generating line values.
  # What we do here, for each line, is to toss 3 (imaginary) coins,
  # count the number of heads and add 6.  If we were really hardcore,
  # we'd instead simulate the mechanical interactions of a bunch of
  # (imaginary) yarrow stalks, which is considered a superior method
  # of consulting the Oracle.  Patches are welcome. =)

  (6 + unpack "%8b*", chr rand 8)
    . (6 + unpack "%8b*", chr rand 8)
      . (6 + unpack "%8b*", chr rand 8)
        . (6 + unpack "%8b*", chr rand 8)
          . (6 + unpack "%8b*", chr rand 8)
            . (6 + unpack "%8b*", chr rand 8);
}

# Get the first and second hexagram of a pair, given the lines.
sub first_hex {
  my ($chg) = @_;
  $chg =~ s/6/8/g;  $chg =~ s/9/7/g;
  $hexagram{$chg};
}
sub second_hex {
  my ($chg) = @_;
  $chg =~ s/6/7/g;  $chg =~ s/9/8/g;
  $hexagram{$chg};
}

## extract data and generate output

# Take the set of lines and display the hexagrams.
sub hexagram {
  my ($change) = @_;	# string of lines

  my $hex1 =  first_hex($change);
  my $hex2 =  second_hex($change);

  my ($macros, $text1, $text2);

  # Read the macro definitions.
  $macros = get_macros();

  # Search for the first hexagram.
  $_ = <DATA> while defined($_) && !/^\.H\s+($hex1|$hex2)\s/;
  defined $_ || die "ching: Hexagram $hex1 or $hex2 missing!\n"; 
  if ($1 eq $hex1) {
    $text1 = get_hex_body($change, $1);
  } else {
    $text2 = get_hex_body('', $1);
  }

  return ($macros, $text1) if $hex1 == $hex2;

  # Search for the second hexagram.
  $_ = <DATA> while defined($_) && !/^\.H\s+($hex1|$hex2)\s/;
  defined $_ || die "ching: Hexagram $hex1 or $hex2 missing!\n";
  if ($1 eq $hex1) {
    $text1 = get_hex_body($change, $1);
  } else {
    $text2 = get_hex_body('', $1);
  }

  defined $text1 && defined $text2
    or die "ching: Hexagram text was repeated!\n";
  ($macros, $text1, $text2);
}

## hexagram text parsing

use vars qw( $show_lines );

## hexagram file format:
#	.H <number> "<Chinese name>" "<English name>"
#	.X <trigram> <trigram>
#	.J
#	<judgement for the hexagram>
#	.I
#	<image for the hexagram>
# for each of the six lines:
#	.L <line-number> <6 or 9> [optional C or G]
#	<change description>
# optional, only for hexagrams 1 (999999) and 2 (666666):
#	.LA <6 or 9>
#	<comment if all lines are 6 or 9>

sub get_hex_body {
  my ($change, $hex) = @_;
  my (@chunk, $body);

  $show_lines = 1;

  # Record the hexagram description, trigrams, judgement and image.
  defined($_) && (@chunk = /^\.H (\d+) "(.*?)" "(.*?)"/) && ($chunk[0] == $hex)
    or die "ching: Hexagram header (.H) is corrupt for hexagram $hex\n";
  $body = handle_hex(@chunk);

  defined($_ = <DATA>) && (@chunk = /^\.X (\d+) (\d+)/)
    or die "ching: Trigrams (.X) are missing for hexagram $hex\n";
  $body .= handle_trigrams(@chunk);

  defined($_ = <DATA>) && /^\.J$/
    or die "ching: Judgement (.J) is missing for hexagram $hex\n";
  @chunk = ($_);
  push @chunk, $_ while defined($_ = <DATA>) && !/^\./;
  $body .= join '', handle_judgement(@chunk);

  defined($_) && /^\.I$/
    or die "ching: Image (.I) is missing for hexagram $hex\n";
  @chunk = ($_);
  push @chunk, $_ while defined($_ = <DATA>) && !/^\./;
  $body .= join '', handle_image(@chunk);

  # Print commentary for each moving line.
  my $line;
  foreach $line (split //, $change) {
    defined($_) && /^\.L /
      or die "ching: Some changes (.L) are missing for hexagram $hex\n";

    @chunk = ($_);
    push @chunk, $_ while defined($_ = <DATA>) && !/^\./;
    $body .= join '', handle_change(@chunk)
      if ($line eq '6') || ($line eq '9');
  }

  # Print appropriate commentary if all lines are changing together.
  if (($change eq '6'x6) || ($change eq '9'x6)) {
    defined($_) && /^\.LA /
      or die "ching: All-lines change (.LA) is missing for hexagram $hex\n";

    @chunk = ($_);
    push @chunk, $_ while defined($_ = <DATA>) && !/^\./;
    $body .= join '', handle_change(@chunk);
  }

  $body;
}

## parsing command line args

=head1 OPTIONS

The B<-n> option will cause *ROFF commands to be piped through nroff(1)
for output formatting, as they were in original BSD implementation.  By
default, the formatting is done by the C<ching> program itself.

The B<-r> option will cause *ROFF formatting commands to be sent to the
standard output.  You probably won't find this very useful unless you're
debugging the B<-n> switch.

The B<-p> option specifies the command to use to display the output.
The default is the value of the environment variable CHING_PAGER, or
of PAGER, or none if neither environment variable is set.

For those who wish to remain steadfast in the old traditions, the
oracle will also accept the results of a personal divination using
yarrow sticks or coins.  To do this, cast the change and then type the
resulting line values as an argument.

Conversely, the B<-h> option can be used to display the line values
from a divination cast by the computer.

=cut

use vars qw( $spew_roff $spew_number );
my ($pager, $format);

while (@ARGV && ($ARGV[0] =~ /^-/)) {
  foreach (split //, shift(@ARGV)) {
    next if $_ eq '-';
    ($_ eq 'n') && ($spew_roff = 1, $format = '| nroff -', next);
    ($_ eq 'r') && ($spew_roff = 1, next);
    ($_ eq 'h') && ($spew_number = 1, next);
    ($_ eq 'p') && (@ARGV || usage, $pager = shift(@ARGV), next);
    usage;
  }
}

@ARGV > 1 and usage;
my $change = @ARGV ? shift @ARGV : ask_and_toss();
$change =~ /^[6789]{6}$/ or usage;

$pager = $ENV{'CHING_PAGER'} unless defined $pager;
$pager = $ENV{'PAGER'}       unless defined $pager;

## generating output

exit !print "$change\n" if $spew_number;

my @output = hexagram($change);

$format = '' unless defined $format;
$format .= "| $pager" if defined $pager && length $pager;

open(SPEW, $format) ? select(SPEW) : warn "Can't open pipe to `$format'"
  if length($format);

print @output;

select(STDOUT);
close(SPEW) if defined fileno SPEW;

## macro extraction

sub get_macros {
  if ($spew_roff) {
    # if outputting roff, just read the macros and return the value
    my $macros;
    {
      local ($/) = "\n__";
      $macros = <DATA>;
      substr($macros, -2, 2, '') eq '__'
        or die "ching: Hexagram text delimiter is missing!\n";
    }
    defined ($_ = <DATA>)
      or die "ching: Hexagram text delimiter ends the file!\n";
    $macros;
  } else {
    # if formatting ourselves, extract various chunks of text
    handle_macro() while defined($_ = <DATA>) && !/^__/;
    defined $_ or die "ching: Hexagram text is missing!\n";
    "\n";
  }
}


## output generation hooks

my %text;

# Handle a line of macro defs
sub handle_macro {
  /^\.ds\s+N(\d)\s+(.*?)$/
    && ($text{"num$1"} = $2, return);
  /^\.ds\s+L(\d)\s+(.*?)$/
    && ($text{"place$1"} = $2, return);

  /^\.ds\s+T(\d)\s+(.*?)$/
    && ($text{"trigram$1"} = $2, return);

  /^\.XX\s.*?"(.*?)"/
    && ($text{exists $text{'above'} ? 'below' : 'above'} = $1, return);

  /^\.ds\s+LH\s+(.*?)$/
    && ($text{'lines'} = $1, return);
  /^([^\.\\\t].*?)$/
    && ($text{exists $text{'judgement'} ? 'image' : 'judgement'} = $1, return);

  /^\\\\\*\(GR\s+\\\\\$1\s+\\\\\$2\s+(.*?)\\/
    && ($text{'means'} = $1, return);

  /'(\d)'\s+\.LX\s+"(.*?)"\s+"(.*?)"/
    && ($text{"all$1"} = "$2 $3", return);
}

# Generate underlining via backspaces.
sub under { my ($text) = @_; $text =~ s/(.)/_\b$1/g; $text; }

# Convert a string into what nroff would print out for it.  (Simplistic.)
sub nroff ($) {
  local ($_) = @_;
  die "ching: oops! internal error" unless defined $_;

  s/\\([ '])/$1/g;              # turn \' into ' etc.
  s/\\fI(.*?)\\fR/under($1)/ge; # map \fI and \fR into underlining
  s/\\f\w//g;                   # skip \fX if not matching
  s/\\\(em/-/g;                 # turn \(em into - [follow nroff, don't use --]
  s/\\o'(.)(.)'/$1\b$2/g;       # make \o'^e' (overstrike) insert a backspace
  $_;
}

# Generate a trigram with appropriate text.
sub trigram {
  my ($tri, $where) = @_;

  my $desc = nroff $text{"trigram$tri"};
  $tri--;
  my @lines = map( ($tri & $_) ? '-- --' : '-----',  4, 2, 1 );

  <<"EndOfTrigram";
          $lines[0]
          $lines[1]     $where     $desc
          $lines[2]
EndOfTrigram
}

# Handle a starting line of a hexagram (return appropriate text)
sub handle_hex {
  return $_ if $spew_roff;          # if outputting roff, just return the line

  my ($num, $chinese, $local) = @_;
  sprintf "\n     %-5.5s%s / %s\n\n", "$num.", nroff $chinese, nroff $local;
}

# Handle a pair of trigrams making up a hexagram (return appropriate text)
sub handle_trigrams {
  return $_ if $spew_roff;          # if outputting roff, just return the line

  my ($top, $bot) = @_;
  trigram($top, nroff $text{'above'})
    . trigram($bot, nroff $text{'below'});
}

# Handle the judgement block for a hexagram (return appropriate text)
sub handle_judgement {
  return @_ if $spew_roff; # if outputting roff, just return the lines

  shift;
  "\n     ", nroff($text{'judgement'}), "\n\n", map ' 'x10 . nroff($_), @_;
}

# Handle the image block for a hexagram (return appropriate text)
sub handle_image {
  return @_ if $spew_roff; # if outputting roff, just return the lines

  shift;
  "\n     ", nroff($text{'image'}), "\n\n", map(' 'x10 . nroff($_), @_), "\n";
}

# Handle the change block for a line (return appropriate text)
sub handle_change {
  return @_ if $spew_roff; # if outputting roff, just return the lines

  my @lines;

  push @lines, "     $text{'lines'}\n\n" if $show_lines;
  $show_lines = 0;

  my ($all, $where, $val, $cg)
    = ($_[0] =~ /^\.L(?:(A)|\s+(\d))\s+(\d)\s*([CG]?)/)
      or die "ching: Malformed change line: $_[0]";
  shift;

  my $mark = ($cg eq 'C' ? '[]' : ($cg eq 'G' ? '()' : ''));

  my $info = nroff $text{$all ? "all$val" : "num$val"};
  $info .= ' ' . nroff $text{"place$where"} if defined $where;
  $info .= ' ' . nroff $text{'means'};

  push @lines, sprintf "     %-5.5s%s\n", $mark, $info;

  @lines, map(' 'x10 . nroff($_), @_), "\n";
}

## final bits of documentation

=head1 COPYRIGHT

The Perl code is copyright (c) 1995, 1999 Albert Dvornik <bert@genscan.com>.

The hexagram text and ROFF macros are Copyright (c) 1988 The Regents
of the University of California.  All rights reserved.  This product
includes software developed by the University of California, Berkeley
and its contributors.

=head2 About The Hexagram Text Copyright

In the original BSD version, the macros and the hexagram text resided
in separate files from the program source, and neither of these files
contained a copyright notice.  I'm working under the assumption that
they were intended to be covered by the same copyright as the program
source, which is the copyright displayed above.  If you have reason to
believe otherwise, please let me know.

Also, please drop me a line if you know of a freely available I<I Ching>
text that's not encumbered by the Obnoxious BSD Advertising Clause.

=head1 SEE ALSO

  It furthers one to see the great man.

=head1 DIAGNOSTICS

  Thus the superior man at nightfall
  Goes indoors for rest and recuperation.

=head1 BUGS

The program does not support simulated tossing of yarrow stalks as a
way of consulting the oracle.

=cut

### NB: This copyright applies *ONLY* to the macros and text, appended below.
# 
# Hexagram text and *ROFF macros Copyright (c) 1988 The Regents of the
# University of California.  All rights reserved.
# 
# Redistribution and use in source and binary forms are permitted
# provided that: (1) source distributions retain this entire copyright
# notice and comment, and (2) distributions including binaries display
# the following acknowledgement: ``This product includes software
# developed by the University of California, Berkeley and its
# contributors'' in the documentation or other materials provided with
# the distribution and in all advertising materials mentioning features
# or use of this software. Neither the name of the University nor the
# names of its contributors may be used to endorse or promote products
# derived from this software without specific prior written permission.
# THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
# WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

__DATA__
.ds N6 Six
.ds N9 Nine
.ds L1 at the beginning
.ds L2 in the second place
.ds L3 in the third place
.ds L4 in the fourth place
.ds L5 in the fifth place
.ds L6 at the top
.ds GR ()
.ds CR []
.ds BL \(em\(em\ \(em\(em
.ds SL \(em\(em\(em\(em\(em
.ds T1 Ch\'ien\ The Creative, Heaven
.ds T2 Sun\ \ \ \ The Gentle, Wind
.ds T3 Li\ \ \ \ \ The Clinging, Flame
.ds T4 K\o'^e'n\ \ \ \ Keeping Still, Mountain
.ds T5 Tui\ \ \ \ The Joyous, Lake
.ds T6 K\'an\ \ \ The Abysmal, Water
.ds T7 Ch\o'^e'n\ \ \ The Arousing, Thunder
.ds T8 K\'un\ \ \ The Receptive, Earth
.de H
.ds LH The Lines
.in 0
.ta 0.5i 1.0i 1.5i 2.0i
.na
.nf
.sp 2
\\$1.	\\$2 / \\$3
..
.de X
.sp
.XX \\$1 "above" "\\*(T\\$1"
.XX \\$2 "below" "\\*(T\\$2"
..
.de XX
.ie \\$1>4 	\\*(BL
.el 	\\*(SL
.ie (\\$1-1%4)>1 	\\*(BL\\c
.el 	\\*(SL\\c
	\\$2	\\$3
.ie \\$1%2 	\\*(SL
.el 	\\*(BL
..
.de J
.in 0
.sp
The Judgement
.na
.nf
.in 0.5i
.sp
..
.de I
.in 0
.sp
The Image
.na
.nf
.sp
.in 0.5i
..
.de LX
.in 0.5i
.ti -0.5i
.if '\\$3'G' \\{\\
\\*(GR	\\$1 \\$2 means:\\}
.if '\\$3'C' \\{\\
\\*(CR	\\$1 \\$2 means:\\}
.if '\\$3'' \\{\\
	\\$1 \\$2 means:\\}
..
.de L
.if !'\\*(LH'' \\{\\
.in 0
.sp
\\*(LH
.rm LH
.in 0.5i\\}
.sp
.LX "\\*(N\\$2" "\\*(L\\$1" \\$3
.na
.nf
..
.de LA
.sp
.if '\\$1'6' .LX "When all the lines are" "sixes, it"
.if '\\$1'9' .LX "When all the lines are" "nines, it"
.na
.nf
..
.po 0.5i
__HEXAGRAM_TEXT__
.H 1 "Ch\'ien" "The Creative"
.X 1 1
.J
The Creative works sublime success,
Furthering through perseverance.
.I
The movement of heaven is full of power.
Thus the superior man makes himself strong and untiring.
.L 1 9
Hidden dragon. Do not act.
.L 2 9
Dragon appearing in the field.
It furthers one to see the great man.
.L 3 9
All day long the superior man is creatively active.
At nightfall his mind is still beset with cares.
Danger. No blame.
.L 4 9
Wavering flight over the depths.
No blame.
.L 5 9 G
Flying dragon in the heavens.
It furthers one to see the great man.
.L 6 9
Arrogant dragon will have cause to repent.
.LA 9
There appears a flight of dragons without heads.
Good fortune.
.H 2 "K\'un" "The Receptive"
.X 8 8
.J
The Receptive brings about sublime success,
Furthering through the perseverance of a mare.
If the superior man undertakes something and tries to lead,
He goes astray;
But if he follows, he finds guidance.
It is favorable to find friends in the west and south,
To forego friends in the east and north.
Quiet perseverance brings good fortune.
.I
The earth's condition is receptive devotion.
Thus the superior man who has breadth of character
Carries the outer world.
.L 1 6
When there is hoarfrost underfoot,
Solid ice is not far off.
.L 2 6 G
Straight, square, great.
Without purpose,
Yet nothing remains unfurthered.
.L 3 6
Hidden lines.
One is able to remain persevering.
If by chance you are in the service of a king,
Seek not works, but bring to completion.
.L 4 6
A tied-up sack. No blame, no praise.
.L 5 6
A yellow lower garment brings supreme good fortune.
.L 6 6
Dragons fight in the meadow.
Their blood is black and yellow.
.LA 6
Lasting perseverance furthers.
.H 3 "Chun" "Difficulty at the Beginning"
.X 6 7
.J
Difficulty at the Beginning works supreme success,
Furthering through perseverance.
Nothing should be undertaken.
It furthers one to appoint helpers.
.I
Clouds and thunder:
The image of Difficulty at the Beginning.
Thus the superior man
Brings order out of confusion.
.L 1 9 G
Hesitation and hindrance.
It furthers one to remain persevering.
It furthers one to appoint helpers.
.L 2 6
Difficulties pile up.
Horse and wagon part.
He is not a robber;
He wants to woo when the time comes.
The maiden is chaste,
She does not pledge herself.
Ten years\(emthen she pledges herself.
.L 3 6
Whoever hunts deer without the forester
Only loses his way in the forest.
The superior man understands the signs of the time
And prefers to desist.
To go on brings humiliation.
.L 4 6
Horse and wagon part.
Strive for union.
To go brings good fortune.
Everything acts to further.
.L 5 9 G
Difficulties in blessing.
A little perseverance brings good fortune.
Great perseverance brings misfortune.
.L 6 6
Horse and wagon part.
Bloody tears flow.
.H 4 "M\o'^e'ng" "Youthful Folly"
.X 4 6
.J
Youthful Folly has success.
It is not I who seek the young fool;
The young fool seeks me.
At the first oracle I inform him.
If he asks two or three times, it is importunity.
If he importunes, I give him no information.
Perseverance furthers.
.I
A spring wells up at the foot of the mountain:
The image of Youth.
Thus the superior man fosters his character
By thoroughness in all that he does.
.L 1 6
To make a fool develop
It furthers one to apply discipline.
The fetters should be removed.
To go on in this way brings humiliation.
.L 2 9 G
To bear with fools in kindliness brings good fortune.
To know how to take women
Brings good fortune.
The son is capable of taking charge of the household.
.L 3 6
Take not a maiden who, when she sees a man of bronze,
Loses possession of herself.
Nothing furthers.
.L 4 6
Entangled folly brings humiliation.
.L 5 6 G
Childlike folly brings good fortune.
.L 6 9
In punishing folly
It does not further one
To commit transgressions.
The only thing that furthers
Is to prevent transgressions.
.H 5 "Hsu" "Waiting (Nourishment)"
.X 6 1
.J
Waiting. If you are sincere,
You have light and success.
Perseverance brings good fortune.
It furthers one to cross the great water.
.I
Clouds rise up to heaven:
The image of Waiting.
Thus the superior man eats and drinks,
Is joyous and of good cheer.
.L 1 9
Waiting in the meadow.
It furthers one to abide in what endures.
No blame.
.L 2 9
Waiting on the sand.
There is some gossip.
The end brings good fortune.
.L 3 9
Waiting in the mud
Brings about the arrival of the enemy.
.L 4 6
Waiting in blood.
Get out of the pit.
.L 5 9 G
Waiting at meat and drink.
Perseverance brings good fortune.
.L 6 6
One falls into the pit.
Three uninvited guests arrive.
Honor them, and in the end there will be good fortune.
.H 6 "Sung" "Conflict"
.X 1 6
.J
Conflict. You are sincere
And are being obstructed.
A cautious halt halfway brings good fortune.
Going through to the end brings misfortune.
It furthers one to see the great man.
It does not further one to cross the great water.
.I
Heaven and water go their opposite ways:
The image of Conflict.
Thus in all his transactions the superior man
Carefully considers the beginning.
.L 1 6
If one does not perpetuate the affair,
There is a little gossip.
In the end, good fortune comes.
.L 2 9
One cannot engage in conflict;
One returns home, gives way.
The people of his town,
Three hundred households,
Remain free of guilt.
.L 3 6
To nourish oneself on ancient virtue induces perseverance.
Danger. In the end, good fortune comes.
If by chance you are in the service of a king,
Seek not works.
.L 4 9
One cannot engage in conflict.
One turns back and submits to fate,
Changes one's attitude,
And finds peace in perseverance.
Good fortune.
.L 5 9 G
To contend before him
Brings supreme good fortune.
.L 6 9
Even if by chance a leather belt is bestowed on one,
By the end of a morning
It will have been snatched away three times.
.H 7 "Shih" "The Army"
.X 8 6
.J
The Army. The army needs perseverance
And a strong man.
Good fortune without blame.
.I
In the middle of the earth is water:
The image of the Army.
Thus the superior man increases his masses
By generosity toward the people.
.L 1 6
An army must set forth in proper order.
If the order is not good, misfortune threatens.
.L 2 9 G
In the midst of the army.
Good fortune. No blame.
The king bestows a triple decoration.
.L 3 6
Perchance the army carries corpses in the wagon.
Misfortune.
.L 4 6
The army retreats. No blame.
.L 5 6 G
There is game in the field.
It furthers one to catch it.
Without blame.
Let the eldest lead the army.
The younger transports corpses;
Then perseverance brings misfortune.
.L 6 6
The great prince issues commands,
Founds states, vests families with fiefs.
Inferior people should not be employed.
.H 8 "Pi" "Holding Together [Union]"
.X 6 8
.J
Holding Together brings good fortune.
Inquire of the oracle once again
Whether you possess sublimity, constancy, and perseverance;
Then there is no blame.
Those who are uncertain gradually join.
Whoever comes too late
Meets with misfortune.
.I
On the earth is water:
The image of Holding Together.
Thus the kings of antiquity
Bestowed the different states as fiefs
And cultivated friendly relations
With the feudal lords.
.L 1 6
Hold to him in truth and loyalty;
This is without blame.
Truth, like a full earthen bowl:
Thus in the end
Good fortune comes from without.
.L 2 6
Hold to him inwardly.
Perseverance brings good fortune.
.L 3 6
You hold together with the wrong people.
.L 4 6
Hold to him outwardly also.
Perseverance brings good fortune.
.L 5 9 G
Manifestation of holding together.
In the hunt the king uses beaters on three sides only
And foregoes game that runs off in front.
The citizens need no warning.
Good fortune.
.L 6 6
He finds no head for holding together.
Misfortune.
.H 9 "Hsiao Ch\'u" "The Taming Power of the Small"
.X 2 1
.J
The Taming Power of the Small
Has success.
Dense clouds, no rain from our western region.
.I
The wind drives across heaven:
The image of the Taming Power of the Small.
Thus the superior man
Refines the outward aspect of his nature.
.L 1 9
Return to the way.
How could there be blame in this?
Good fortune.
.L 2 9
He allows himself to be drawn into returning.
Good fortune.
.L 3 9
The spokes burst out of the wagon wheels.
Man and wife roll their eyes.
.L 4 6 C
If you are sincere, blood vanishes and fear gives way.
No blame.
.L 5 9 G
If you are sincere and loyally attached,
You are rich in your neighbor.
.L 6 9
The rain comes, there is rest.
This is due to the lasting effect of character.
Perseverance brings the woman into danger.
The moon is nearly full.
If the superior man persists,
Misfortune comes.
.H 10 "Lu" "Treading [Conduct]"
.X 1 5
.J
Treading. Treading upon the tail of the tiger.
It does not bite the man. Success.
.I
Heaven above, the lake below:
The image of Treading.
Thus the superior man discriminates between high and low,
And thereby fortifies the thinking of the people.
.L 1 9
Simple conduct. Progress without blame.
.L 2 9
Treading a smooth, level course.
The perseverance of a dark man
Brings good fortune.
.L 3 6 C
A one-eyed man is able to see,
A lame man is able to tread.
He treads on the tail of the tiger.
The tiger bites the man.
Misfortune.
Thus does a warrior act on behalf of his great prince.
.L 4 9
He treads on the tail of the tiger.
Caution and circumspection
Lead ultimately to good fortune.
.L 5 9 G
Resolute conduct.
Perseverance with awareness of danger.
.L 6 9
Look to your conduct and weigh the favorable signs.
When everything is fulfilled, supreme good fortune comes.
.H 11 "T\'ai" "Peace"
.X 8 1
.J
Peace. The small departs,
The great approaches.
Good fortune. Success.
.I
Heaven and earth unite: the image of Peace.
Thus the ruler
Divides and completes the course of heaven and earth;
He furthers and regulates the gifts of heaven and earth,
And so aids the people.
.L 1 9
When ribbon grass is pulled up, the sod comes with it.
Each according to his kind.
Undertakings bring good fortune.
.L 2 9 G
Bearing with the uncultured in gentleness,
Fording the river with resolution,
Not neglecting what is distant,
Not regarding one's companions:
Thus one may manage to walk in the middle.
.L 3 9
No plain not followed by a slope.
No going not followed by a return.
He who remains persevering in danger
Is without blame.
Do not complain about this truth;
Enjoy the good fortune you still possess.
.L 4 6
He flutters down, not boasting of his wealth,
Together with his neighbor,
Guileless and sincere.
.L 5 6 G
The sovereign I
Gives his daughter in marriage.
This brings blessing
And supreme good fortune.
.L 6 6
The wall falls back into the moat.
Use no army now.
Make your commands known within your own town.
Perseverance brings humiliation.
.H 12 "P\'i" "Standstill [Stagnation]"
.X 1 8
.J
Standstill. Evil people do not further
The perseverance of the superior man.
The great departs; the small approaches.
.I
Heaven and earth do not unite:
The image of Standstill.
Thus the superior man falls back upon his inner worth
In order to escape the difficulties.
He does not permit himself to be honored with revenue.
.L 1 6
When ribbon grass is pulled up, the sod comes with it.
Each according to his kind.
Perseverance brings good fortune and success.
.L 2 6 C
They bear and endure;
This means good fortune for inferior people.
The standstill serves to help the great man to attain success.
.L 3 6
They bear shame.
.L 4 9
He who acts at the command of the highest
Remains without blame.
Those of like mind partake of the blessing.
.L 5 9 G
Standstill is giving way.
Good fortune for the great man.
"What if it should fail, what if it should fail?"
In this way he ties it to a cluster of mulberry shoots.
.L 6 9
The standstill comes to an end.
First standstill, then good fortune.
.H 13 "T\'ung J\o'^e'n" "Fellowship with Men"
.X 1 3
.J
Fellowship with Men in the open.
Success.
It furthers one to cross the great water.
The perseverance of the superior man furthers.
.I
Heaven together with fire:
The image of Fellowship with Men.
Thus the superior man organizes the clans
And makes distinctions between things.
.L 1 9
Fellowship with men at the gate.
No blame.
.L 2 6 G
Fellowship with men in the clan.
Humiliation.
.L 3 9
He hides weapons in the thicket;
He climbs the high hill in front of it.
For three years he does not rise up.
.L 4 9
He climbs up on his wall; he cannot attack.
Good fortune.
.L 5 9 G
Men bound in fellowship first weep and lament,
But afterward they laugh.
After great struggles they succeed in meeting.
.L 6 9
Fellowship with men in the meadow.
No remorse.
.H 14 "Ta Yu" "Possession in Great Measure"
.X 3 1
.J
Possession in Great Measure.
Supreme success.
.I
Fire in heaven above:
The image of Possession in Great Measure.
Thus the superior man curbs evil and furthers good,
And thereby obeys the benevolent will of heaven.
.L 1 9
No relationship with what is harmful;
There is no blame in this.
If one remains conscious of difficulty,
One remains without blame.
.L 2 9
A big wagon for loading.
One may undertake something.
No blame.
.L 3 9
A prince offers it to the Son of Heaven.
A petty man cannot do this.
.L 4 9
He makes a difference
Between himself and his neighbor.
No blame.
.L 5 6 G
He whose truth is accessible, yet dignified,
Has good fortune.
.L 6 9
He is blessed by heaven.
Good fortune.
Nothing that does not further.
.H 15 "Ch\'ien" "Modesty"
.X 8 4
.J
Modesty creates success.
The superior man carries things through.
.I
Within the earth, a mountain:
The image of Modesty.
Thus the superior man reduces that which is too much,
And augments that which is too little.
He weighs things and makes them equal.
.L 1 6
A superior man modest about his modesty
May cross the great water.
Good fortune.
.L 2 6
Modesty that comes to expression.
Perseverance brings good fortune.
.L 3 9 G
A superior man of modesty and merit
Carries things to conclusion.
Good fortune.
.L 4 6
Nothing that would not further modesty
In movement.
.L 5 6
No boasting of wealth before one's neighbor.
It is favorable to attack with force.
Nothing that would not further.
.L 6 6
Modesty that comes to expression.
It is favorable to set armies marching
To chastise one's own city and one's country.
.H 16 "Yu" "Enthusiasm"
.X 7 8
.J
Enthusiasm. It furthers one to install helpers
And to set armies marching.
.I
Thunder comes resounding out of the earth:
The image of Enthusiasm.
Thus the ancient kings made music
In order to honor merit,
And offered it with splendor
To the Supreme Deity,
Inviting their ancestors to be present.
.L 1 6
Enthusiasm that expresses itself
Brings misfortune.
.L 2 6
Firm as a rock. Not a whole day.
Perseverance brings good fortune.
.L 3 6
Enthusiasm that looks upward creates remorse.
Hesitation brings remorse.
.L 4 9 G
The source of enthusiasm.
He achieves great things.
Doubt not.
You gather friends around you
As a hair clasp gathers the hair.
.L 5 6
Persistently ill, and still does not die.
.L 6 6
Deluded enthusiasm.
But if after completion one changes,
There is no blame.
.H 17 "Sui" "Following"
.X 5 7
.J
Following has supreme success.
Perseverance furthers. No blame.
.I
Thunder in the middle of the lake:
The image of Following.
Thus the superior man at nightfall
Goes indoors for rest and recuperation.
.L 1 9 G
The standard is changing.
Perseverance brings good fortune.
To go out of the door in company
Produces deeds.
.L 2 6
If one clings to the little boy,
One loses the strong man.
.L 3 6
If one clings to the strong man,
One loses the little boy.
Through following one finds what one seeks.
It furthers one to remain persevering.
.L 4 9
Following creates success.
Perseverance brings misfortune.
To go one's way with sincerity brings clarity.
How could there be blame in this?
.L 5 9 G
Sincere in the good. Good fortune.
.L 6 6
He meets with firm allegiance
And is still further bound.
The king introduces him
To the Western Mountain.
.H 18 "Ku" "Work on What Has Been Spoiled [Decay]"
.X 4 2
.J
Work on What Has Been Spoiled
Has supreme success.
It furthers one to cross the great water.
Before the starting point, three days.
After the starting point, three days.
.I
The wind blows low on the mountain:
The image of Decay.
Thus the superior man stirs up the people
And strengthens their spirit.
.L 1 6
Setting right what has been spoiled by the father.
If there is a son,
No blame rests upon the departed father.
Danger. In the end good fortune.
.L 2 9
Setting right what has been spoiled by the mother.
One must not be too persevering.
.L 3 9
Setting right what has been spoiled by the father.
There will be little remorse. No great blame.
.L 4 6
Tolerating what has been spoiled by the father.
In continuing one sees humiliation.
.L 5 6 G
Setting right what has been spoiled by the father.
One meets with praise.
.L 6 9
He does not serve kings and princes,
Sets himself higher goals.
.H 19 "Lin" "Approach"
.X 8 5
.J
Approach has supreme success.
Perseverance furthers.
When the eighth month comes,
There will be misfortune.
.I
The earth above the lake:
The image of Approach.
Thus the superior man is inexhaustible
In his will to teach,
And without limits
In his tolerance and protection of the people.
.L 1 9 G
Joint approach.
Perseverance brings good fortune.
.L 2 9 G
Joint approach.
Good fortune.
Everything furthers.
.L 3 6
Comfortable approach.
Nothing that would further.
If one is induced to grieve over it,
One becomes free of blame.
.L 4 6
Complete approach.
No blame.
.L 5 6
Wise approach.
This is right for a great prince.
Good fortune.
.L 6 6
Greathearted approach.
Good fortune. No blame.
.H 20 "Kuan" "Contemplation (View)"
.X 2 8
.J
Contemplation. The ablution has been made,
But not yet the offering.
Full of trust they look up to him.
.I
The wind blows over the earth:
The image of Contemplation.
Thus the kings of old visited the regions of the world,
Contemplated the people,
And gave them instruction.
.L 1 6
Boylike contemplation.
For an inferior man, no blame.
For a superior man, humiliation.
.L 2 6
Contemplation through the crack of the door.
Furthering for the perseverance of a woman.
.L 3 6
Contemplation of my life
Decides the choice
Between advance and retreat.
.L 4 6
Contemplation of the light of the kingdom.
It furthers one to exert influence as the guest of a king.
.L 5 9 G
Contemplation of my life.
The superior man is without blame.
.L 6 9 G
Contemplation of his life.
The superior man is without blame.
.H 21 "Shih Ho" "Biting Through"
.X 3 7
.J
Biting Through has success.
It is favorable to let justice be administered.
.I
Thunder and lightning:
The image of Biting Through.
Thus the kings of former times made firm the laws
Through clearly defined penalties.
.L 1 9
His feet are fastened in the stocks,
So that his toes disappear.
No blame.
.L 2 6
Bites through tender meat,
So that his nose disappears.
No blame.
.L 3 6
Bites on old dried meat
And strikes on something poisonous.
Slight humiliation. No blame.
.L 4 9
Bites on dried gristly meat.
Receives metal arrows.
It furthers one to be mindful of difficulties
And to be persevering.
Good fortune.
.L 5 6 G
Bites on dried lean meat.
Receives yellow gold.
Perseveringly aware of danger.
No blame.
.L 6 9
His neck is fastened in the wooden cangue,
So that his ears disappear.
Misfortune.
.H 22 "Pi" "Grace"
.X 4 3
.J
Grace has success.
In small matters
It is favorable to undertake something.
.I
Fire at the foot of the mountain:
The image of Grace.
Thus does the superior man proceed
When clearing up current affairs.
But he dare not decide controversial issues in this way.
.L 1 9
He lends grace to his toes, leaves the carriage, and walks.
.L 2 6 G
Lends grace to the beard on his chin.
.L 3 9
Graceful and moist.
Constant perseverance brings good fortune.
.L 4 6
Grace or simplicity?
A white horse comes as if on wings.
He is not a robber,
He will woo at the right time.
.L 5 6
Grace in hills and gardens.
The roll of silk is meager and small.
Humiliation, but in the end good fortune.
.L 6 9 G
Simple grace. No blame.
.H 23 "Po" "Splitting Apart"
.X 4 8
.J
Splitting Apart. It does not further one
To go anywhere.
.I
The mountain rests on the earth:
The image of Splitting Apart.
Thus those above can ensure their position
Only by giving generously to those below.
.L 1 6
The leg of the bed is split.
Those who persevere are destroyed.
Misfortune.
.L 2 6
The bed is split at the edge.
Those who persevere are destroyed.
Misfortune.
.L 3 6
He splits with them. No blame.
.L 4 6
The bed is split up to the skin.
Misfortune.
.L 5 6
A shoal of fishes. Favor comes through the court ladies.
Everything acts to further.
.L 6 9 G
There is a large fruit still uneaten.
The superior man receives a carriage.
The house of the inferior man is split apart.
.H 24 "Fu" "Return (The Turning Point)"
.X 8 7
.J
Return. Success.
Going out and coming in without error.
Friends come without blame.
To and fro goes the way.
On the seventh day comes return.
It furthers one to have somewhere to go.
.I
Thunder within the earth:
The image of the Turning Point.
Thus the kings of antiquity closed the passes
At the time of solstice.
Merchants and strangers did not go about,
And the ruler
Did not travel through the provinces.
.L 1 9 G
Return from a short distance.
No need for remorse.
Great good fortune.
.L 2 6
Quiet return. Good fortune.
.L 3 6
Repeated return. Danger. No blame.
.L 4 6
Walking in the midst of others,
One returns alone.
.L 5 6
Noblehearted return. No remorse.
.L 6 6
Missing the return. Misfortune.
Misfortune from within and without.
If armies are set marching in this way,
One will in the end suffer a great defeat,
Disastrous for the ruler of the country.
For ten years
It will not be possible to attack again.
.H 25 "Wu Wang" "Innocence (The Unexpected)"
.X 1 7
.J
Innocence. Supreme success.
Perseverance furthers.
If someone is not as he should be,
He has misfortune,
And it does not further him
To undertake anything.
.I
Under heaven thunder rolls:
All things attain the natural state of innocence.
Thus the kings of old,
Rich in virtue, and in harmony with the time,
Fostered and nourished all beings.
.L 1 9 G
Innocent behavior brings good fortune.
.L 2 6
If one does not count on the harvest while plowing,
Nor on the use of the ground while clearing it,
It furthers one to undertake something.
.L 3 6
Undeserved misfortune.
The cow that was tethered by someone
Is the wanderer's gain, the citizen's loss.
.L 4 9
He who can be persevering
Remains without blame.
.L 5 9 G
Use no medicine in an illness
Incurred through no fault of your own.
It will pass of itself.
.L 6 9
Innocent action brings misfortune.
Nothing furthers.
.H 26 "Ta Ch\'u" "The Taming Power of the Great"
.X 4 1
.J
The Taming Power of the Great.
Perseverance furthers.
Not eating at home brings good fortune.
It furthers one to cross the great water.
.I
Heaven within the mountain:
The image of the Taming Power of the Great.
Thus the superior man acquaints himself with many sayings of antiquity
And many deeds of the past,
In order to strengthen his character thereby.
.L 1 9
Danger is at hand. It furthers one to desist.
.L 2 9
The axletrees are taken from the wagon.
.L 3 9
A good horse that follows others.
Awareness of danger,
With perseverance, furthers.
Practice chariot driving and armed defense daily.
It furthers one to have somewhere to go.
.L 4 6
The headboard of a young bull.
Great good fortune.
.L 5 6 G
The tusk of a gelded boar.
Good fortune.
.L 6 9 G
One attains the way of heaven. Success.
.H 27 "I" "The Corners of the Mouth (Providing Nourishment)"
.X 4 7
.J
The Corners of the Mouth.
Perseverance brings good fortune.
Pay heed to the providing of nourishment
And to what a man seeks
To fill his own mouth with.
.I
At the foot of the mountain, thunder:
The image of Providing Nourishment.
Thus the superior man is careful of his words
And temperate in eating and drinking.
.L 1 9
You let your magic tortoise go,
And look at me with the corners of your mouth drooping.
Misfortune.
.L 2 6
Turning to the summit for nourishment,
Deviating from the path
To seek nourishment from the hill.
Continuing to do this brings misfortune.
.L 3 6
Turning away from nourishment.
Perseverance brings misfortune.
Do not act thus for ten years.
Nothing serves to further.
.L 4 6
Turning to the summit
For provision of nourishment
Brings good fortune.
Spying about with sharp eyes
Like a tiger with insatiable craving.
No blame.
.L 5 6 G
Turning away from the path.
To remain persevering brings good fortune.
One should not cross the great water.
.L 6 9 G
The source of nourishment.
Awareness of danger brings good fortune.
It furthers one to cross the great water.
.H 28 "Ta Kuo" "Preponderance of the Great"
.X 5 2
.J
Preponderance of the Great.
The ridgepole sags to the breaking point.
It furthers one to have somewhere to go.
Success.
.I
The lake rises above the trees:
The image of Preponderance of the Great.
Thus the superior man, when he stands alone,
Is unconcerned,
And if he has to renounce the world,
He is undaunted.
.L 1 6
To spread white rushes underneath.
No blame.
.L 2 9 G
A dry poplar sprouts at the root.
An older man takes a young wife.
Everything furthers.
.L 3 9
The ridgepole sags to the breaking point.
Misfortune.
.L 4 9 G
The ridgepole is braced. Good fortune.
If there are ulterior motives, it is humiliating.
.L 5 9
A withered poplar puts forth flowers.
An older woman takes a husband.
No blame. No praise.
.L 6 6
One must go through the water.
It goes over one's head.
Misfortune. No blame.
.H 29 "K\'an" "The Abysmal (Water)"
.X 6 6
.J
The Abysmal repeated.
If you are sincere, you have success in your heart,
And whatever you do succeeds.
.I
Water flows on uninterruptedly and reaches its goal:
The image of the Abysmal repeated.
Thus the superior man walks in lasting virtue
And carries on the business of teaching.
.L 1 6
Repetition of the Abysmal.
In the abyss one falls into a pit.
Misfortune.
.L 2 9 G
The abyss is dangerous.
One should strive to attain small things only.
.L 3 6
Forward and backward, abyss on abyss.
In danger like this, pause at first and wait,
Otherwise you will fall into a pit in the abyss.
Do not act in this way.
.L 4 6
A jug of wine, a bowl of rice with it;
Earthen vessels
Simply handed in through the window.
There is certainly no blame in this.
.L 5 9 G
The abyss is not filled to overflowing,
It is filled only to the rim.
No blame.
.L 6 6
Bound with cords and ropes,
Shut in between thorn-hedged prison walls:
For three years one does not find the way.
Misfortune.
.H 30 "Li" "The Clinging, Fire"
.X 3 3
.J
The Clinging. Perseverance furthers.
It brings success.
Care of the cow brings good fortune.
.I
That which is bright rises twice:
The image of Fire.
Thus the great man, by perpetuating this brightness,
Illumines the four quarters of the world.
.L 1 9
The footprints run crisscross.
If one is seriously intent, no blame.
.L 2 6 G
Yellow light. Supreme good fortune.
.L 3 9
In the light of the setting sun,
Men either beat the pot and sing
Or loudly bewail the approach of old age.
Misfortune.
.L 4 9
Its coming is sudden;
It flames up, dies down, is thrown away.
.L 5 6 G
Tears in floods, sighing and lamenting.
Good fortune.
.L 6 9
The king uses him to march forth and chastise.
Then it is best to kill the leaders
And take captive the followers. No blame.
.H 31 "Hsien" "Influence (Wooing)"
.X 5 4
.J
Influence. Success.
Perseverance furthers.
To take a maiden to wife brings good fortune.
.I
A lake on the mountain:
The image of Influence.
Thus the superior man encourages people to approach him
By his readiness to receive them.
.L 1 6
The influence shows itself in the big toe.
.L 2 6
The influence shows itself in the calves of the legs.
Misfortune.
Tarrying brings good fortune.
.L 3 9
The influence shows itself in the thighs.
Holds to that which follows it.
To continue is humiliating.
.L 4 9 G
Perseverance brings good fortune.
Remorse disappears.
If a man is agitated in mind,
And his thoughts go hither and thither,
Only those friends
On whom he fixes his conscious thoughts
Will follow.
.L 5 9 G
The influence shows itself in the back of the neck.
No remorse.
.L 6 6
The influence shows itself in the jaws, cheeks, and tongue.
.H 32 "H\o'^e'ng" "Duration"
.X 7 2
.J
Duration. Success. No blame.
Perseverance furthers.
It furthers one to have somewhere to go.
.I
Thunder and wind: the image of Duration.
Thus the superior man stands firm
And does not change his direction.
.L 1 6
Seeking duration too hastily brings misfortune persistently.
Nothing that would further.
.L 2 9 G
Remorse disappears.
.L 3 9
He who does not give duration to his character
Meets with disgrace.
Persistent humiliation.
.L 4 9
No game in the field.
.L 5 6
Giving duration to one's character through perseverance.
This is good fortune for a woman, misfortune for a man.
.L 6 6
Restlessness as an enduring condition brings misfortune.
.H 33 "Tun" "Retreat"
.X 1 4
.J
Retreat. Success.
In what is small, perseverance furthers.
.I
Mountain under heaven: the image of Retreat.
Thus the superior man keeps the inferior man at a distance,
Not angrily but with reserve.
.L 1 6 C
At the tail in retreat. This is dangerous.
One must not wish to undertake anything.
.L 2 6 C
He holds him fast with yellow oxhide.
No one can tear him loose.
.L 3 9
A halted retreat
Is nerve-wracking and dangerous.
To retain people as men- and maidservants
Brings good fortune.
.L 4 9
Voluntary retreat brings good fortune to the superior man
And downfall to the inferior man.
.L 5 9 G
Friendly retreat. Perseverance brings good fortune.
.L 6 9
Cheerful retreat. Everything serves to further.
.H 34 "Ta Chuang" "The Power of the Great"
.X 7 1
.J
The Power of the Great. Perseverance furthers.
.I
Thunder in heaven above:
The image of the Power of the Great.
Thus the superior man does not tread upon paths
That do not accord with established order.
.L 1 9
Power in the toes.
Continuing brings misfortune.
This is certainly true.
.L 2 9
Perseverance brings good fortune.
.L 3 9
The inferior man works through power.
The superior man does not act thus.
To continue is dangerous.
A goat butts against a hedge
And gets its horns entangled.
.L 4 9 G
Perseverance brings good fortune.
Remorse disappears.
The hedge opens; there is no entanglement.
Power depends upon the axle of a big cart.
.L 5 6
Loses the goat with ease.
No remorse.
.L 6 6
A goat butts against a hedge.
It cannot go backward, it cannot go forward.
Nothing serves to further.
If one notes the difficulty, this brings good fortune.
.H 35 "Chin" "Progress"
.X 3 8
.J
Progress. The powerful prince
Is honored with horses in large numbers.
In a single day he is granted audience three times.
.I
The sun rises over the earth:
The image of Progress.
Thus the superior man himself
Brightens his bright virtue.
.L 1 6
Progressing, but turned back.
Perseverance brings good fortune.
If one meets with no confidence, one should remain calm.
No mistake.
.L 2 6
Progressing, but in sorrow.
Perseverance brings good fortune.
Then one obtains great happiness from one's ancestress.
.L 3 6
All are in accord. Remorse disappears.
.L 4 9
Progress like a hamster.
Perseverance brings danger.
.L 5 6 G
Remorse disappears.
Take not gain and loss to heart.
Undertakings bring good fortune.
Everything serves to further.
.L 6 9
Making progress with the horns is permissible
Only for the purpose of punishing one's own city.
To be conscious of danger brings good fortune.
No blame.
Perseverance brings humiliation.
.H 36 "Ming I" "Darkening of the Light"
.X 8 3
.J
Darkening of the Light. In adversity
It furthers one to be persevering.
.I
The light has sunk into the earth:
The image of Darkening of the Light.
Thus does the superior man live with the great mass:
He veils his light, yet still shines.
.L 1 9
Darkening of the light during flight.
He lowers his wings.
The superior man does not eat for three days
On his wanderings.
But he has somewhere to go.
The host has occasion to gossip about him.
.L 2 6 G
Darkening of the light injures him in the left thigh.
He gives aid with the strength of a horse.
Good fortune.
.L 3 9
Darkening of the light during the hunt in the south.
Their great leader is captured.
One must not expect perseverance too soon.
.L 4 6
He penetrates the left side of the belly.
One gets at the very heart of the darkening of the light,
And leaves gate and courtyard.
.L 5 6 G
Darkening of the light as with Prince Chi.
Perseverance furthers.
.L 6 6 C
Not light but darkness.
First he climbed up to heaven,
Then he plunged into the depths of the earth.
.H 37 "Chia J\o'^e'n" "The Family [The Clan]"
.X 2 3
.J
The Family. The perseverance of the woman furthers.
.I
Wind comes forth from fire:
The image of the Family.
Thus the superior man has substance in his words
And duration in his way of life.
.L 1 9
Firm seclusion within the family.
Remorse disappears.
.L 2 6 G
She should not follow her whims.
She must attend within to the food.
Perseverance brings good fortune.
.L 3 9
When tempers flare up in the family,
Too great severity brings remorse.
Good fortune nonetheless.
When woman and child dally and laugh,
It leads in the end to humiliation.
.L 4 6
She is the treasure of the house.
Great good fortune.
.L 5 9 G
As a king he approaches his family.
Fear not.
Good fortune.
.L 6 9
His work commands respect.
In the end good fortune comes.
.H 38 "K\'uei" "Opposition"
.X 3 5
.J
Opposition. In small matters, good fortune.
.I
Above, fire; below, the lake:
The image of Opposition.
Thus amid all fellowship
The superior man retains his individuality.
.L 1 9
Remorse disappears.
If you lose your horse, do not run after it;
It will come back of its own accord.
When you see evil people,
Guard yourself against mistakes.
.L 2 9 G
One meets his lord in a narrow street.
No blame.
.L 3 6
One sees the wagon dragged back,
The oxen halted,
A man's hair and nose cut off.
Not a good beginning, but a good end.
.L 4 9
Isolated through opposition,
One meets a like-minded man
With whom one can associate in good faith.
Despite the danger, no blame.
.L 5 6 G
Remorse disappears.
The companion bites his way through the wrappings.
If one goes to him,
How could it be a mistake?
.L 6 9
Isolated through opposition,
One sees one's companion as a pig covered with dirt,
As a wagon full of devils.
First one draws a bow against him,
Then one lays the bow aside.
He is not a robber; he will woo at the right time.
As one goes, rain falls; then good fortune comes.
.H 39 "Chien" "Obstruction"
.X 6 4
.J
Obstruction. The southwest furthers.
The northeast does not further.
It furthers one to see the great man.
Perseverance brings good fortune.
.I
Water on the mountain:
The image of Obstruction.
Thus the superior man turns his attention to himself
And molds his character.
.L 1 6
Going leads to obstructions,
Coming meets with praise.
.L 2 6
The king's servant is beset by obstruction upon obstruction,
But it is not his own fault.
.L 3 9
Going leads to obstructions;
Hence he comes back.
.L 4 6
Going leads to obstructions,
Coming leads to union.
.L 5 9 G
In the midst of the greatest obstructions,
Friends come.
.L 6 6
Going leads to obstructions,
Coming leads to great good fortune.
It furthers one to see the great man.
.H 40 "Hsieh" "Deliverance"
.X 7 6
.J
Deliverance. The southwest furthers.
If there is no longer anything where one has to go,
Return brings good fortune.
If there is still something where one has to go,
Hastening brings good fortune.
.I
Thunder and rain set in:
The image of Deliverance.
Thus the superior man pardons mistakes
And forgives misdeeds.
.L 1 6
Without blame.
.L 2 9 G
One kills three foxes in the field
And receives a yellow arrow.
Perseverance brings good fortune.
.L 3 6
If a man carries a burden on his back
And nonetheless rides in a carriage,
He thereby encourages robbers to draw near.
Perseverance leads to humiliation.
.L 4 9
Deliver yourself from your great toe.
Then the companion comes,
And him you can trust.
.L 5 6 G
If only the superior man can deliver himself,
It brings good fortune.
Thus he proves to inferior men that he is in earnest.
.L 6 6
The prince shoots at a hawk on a high wall.
He kills it. Everything serves to further.
.H 41 "Sun" "Decrease"
.X 4 5
.J
Decrease combined with sincerity
Brings about supreme good fortune
Without blame.
One may be persevering in this.
It furthers one to undertake something.
How is this to be carried out?
One may use two small bowls for the sacrifice.
.I
At the foot of the mountain, the lake:
The image of Decrease.
Thus the superior man controls his anger
And restrains his instincts.
.L 1 9
Going quickly when one's tasks are finished
Is without blame.
But one must reflect on how much one may decrease others.
.L 2 9
Perseverance furthers.
To undertake something brings misfortune.
Without decreasing oneself,
One is able to bring increase to others.
.L 3 6 C
When three people journey together,
Their number decreases by one.
When one man journeys alone,
He finds a companion.
.L 4 6
If a man decreases his faults,
It makes the other hasten to come and rejoice.
No blame.
.L 5 6 G
Someone does indeed increase him.
Ten pairs of tortoises cannot oppose it.
Supreme good fortune.
.L 6 9 C
If one is increased without depriving others,
There is no blame.
Perseverance brings good fortune.
It furthers one to undertake something.
One obtains servants
But no longer has a separate home.
.H 42 "I" "Increase"
.X 2 7
.J
Increase. It furthers one
To undertake something.
It furthers one to cross the great water.
.I
Wind and thunder: the image of Increase.
Thus the superior man:
If he sees good, he imitates it;
If he has faults, he rids himself of them.
.L 1 9 C
It furthers one to accomplish great deeds.
Supreme good fortune. No blame.
.L 2 6 G
Someone does indeed increase him;
Ten pairs of tortoises cannot oppose it.
Constant perseverance brings good fortune.
The king presents him before God.
Good fortune.
.L 3 6
One is enriched through unfortunate events.
No blame, if you are sincere
And walk in the middle,
And report with a seal to the prince.
.L 4 6 C
If you walk in the middle
And report to the prince,
He will follow.
It furthers one to be used
In the removal of the capital.
.L 5 9 G
If in truth you have a kind heart, ask not.
Supreme good fortune.
Truly, kindness will be recognized as your virtue.
.L 6 9
He brings increase to no one.
Indeed, someone even strikes him.
He does not keep his heart constantly steady.
Misfortune.
.H 43 "Kuai" "Break-through (Resoluteness)"
.X 5 1
.J
Break-through. One must resolutely make the matter known
At the court of the king.
It must be announced truthfully. Danger.
It is necessary to notify one's own city.
It does not further to resort to arms.
It furthers one to undertake something.
.I
The lake has risen up to heaven:
The image of Break-through.
Thus the superior man
Dispenses riches downward
And refrains from resting on his virtue.
.L 1 9
Mighty in the forward-striding toes.
When one goes and is not equal to the task,
One makes a mistake.
.L 2 9
A cry of alarm. Arms at evening and at night.
Fear nothing.
.L 3 9
To be powerful in the cheekbones
Brings misfortune.
The superior man is firmly resolved.
He walks alone and is caught in the rain.
He is bespattered,
And people murmur against him.
No blame.
.L 4 9
There is no skin on his thighs,
And walking comes hard.
If a man were to let himself be led like a sheep,
Remorse would disappear.
But if these words are heard
They will not be believed.
.L 5 9 G
In dealing with weeds,
Firm resolution is necessary.
Walking in the middle
Remains free of blame.
.L 6 6 C
No cry.
In the end misfortune comes.
.H 44 "Kou" "Coming to Meet"
.X 1 2
.J
Coming to Meet. The maiden is powerful.
One should not marry such a maiden.
.I
Under heaven, wind:
The image of Coming to Meet.
Thus does the prince act when disseminating his commands
And proclaiming them to the four quarters of heaven.
.L 1 6 C
It must be checked with a brake of bronze.
Perseverance brings good fortune.
If one lets it take its course, one experiences misfortune.
Even a lean pig has it in him to rage around.
.L 2 9 G
There is a fish in the tank. No blame.
Does not further guests.
.L 3 9
There is no skin on his thighs,
And walking comes hard.
If one is mindful of the danger,
No great mistake is made.
.L 4 9
No fish in the tank.
This leads to misfortune.
.L 5 9 G
A melon covered with willow leaves.
Hidden lines.
Then it drops down to one from heaven.
.L 6 9
He comes to meet with his horns.
Humiliation. No blame.
.H 45 "Ts\'ui" "Gathering Together [Massing]"
.X 5 8
.J
Gathering Together. Success.
The king approaches his temple.
It furthers one to see the great man.
This brings success. Perseverance furthers.
To bring great offerings creates good fortune.
It furthers one to undertake something.
.I
Over the earth, the lake:
The image of Gathering Together.
Thus the superior man renews his weapons
In order to meet the unforseen.
.L 1 6
If you are sincere, but not to the end,
There will sometimes be confusion, sometimes gathering together.
If you call out,
Then after one grasp of the hand you can laugh again.
Regret not. Going is without blame.
.L 2 6
Letting oneself be drawn
Brings good fortune and remains blameless.
If one is sincere,
It furthers one to bring even a small offering.
.L 3 6
Gathering together amid sighs.
Nothing that would further.
Going is without blame.
Slight humiliation.
.L 4 9 G
Great good fortune. No blame.
.L 5 9 G
If in gathering together one has position,
This brings no blame.
If there are some who are not yet sincerely in the work,
Sublime and enduring perseverance is needed.
Then remorse disappears.
.L 6 6
Lamenting and sighing, floods of tears.
No blame.
.H 46 "Sh\o'^e'ng" "Pushing Upward"
.X 8 2
.J
Pushing Upward has supreme success.
One must see the great man.
Fear not.
Departure toward the south
Brings good fortune.
.I
Within the earth, wood grows:
The image of Pushing Upward.
Thus the superior man of devoted character
Heaps up small things
In order to achieve something high and great.
.L 1 6 C
Pushing upward that meets with confidence
Brings great good fortune.
.L 2 9
If one is sincere,
It furthers one to bring even a small offering.
No blame.
.L 3 9
One pushes upward into an empty city.
.L 4 6
The king offers him Mount Ch'i.
Good fortune. No blame.
.L 5 6 G
Perseverance brings good fortune.
One pushes upward by steps.
.L 6 6
Pushing upward in darkness.
It furthers one
To be unremittingly persevering.
.H 47 "K\'un" "Oppression (Exhaustion)"
.X 5 6
.J
Oppression. Success. Perseverance.
The great man brings about good fortune.
No blame.
When one has something to say,
It is not believed.
.I
There is no water in the lake:
The image of Exhaustion.
Thus the superior man stakes his life
On following his will.
.L 1 6
One sits oppressed under a bare tree
And strays into a gloomy valley.
For three years one sees nothing.
.L 2 9 G
One is oppressed while at meat and drink.
The man with the scarlet knee bands is just coming.
It furthers one to offer sacrifice.
To set forth brings misfortune.
No blame.
.L 3 6
A man permits himself to be oppressed by stone,
And leans on thorns and thistles.
He enters his house and does not see his wife.
Misfortune.
.L 4 9
He comes very quietly, oppressed in a golden carriage.
Humiliation, but the end is reached.
.L 5 9 G
His nose and feet are cut off.
Oppression at the hands of the man with the purple knee bands.
Joy comes softly.
It furthers one to make offerings and libations.
.L 6 6
He is oppressed by creeping vines.
He moves uncertainly and says, "Movement brings remorse."
If one feels remorse over this and makes a start,
Good fortune comes.
.H 48 "Ching" "The Well"
.X 6 2
.J
The Well. The town may be changed,
But the well cannot be changed.
It neither decreases nor increases.
They come and go and draw from the well.
If one gets down almost to the water
And the rope does not go all the way,
Or the jug breaks, it brings misfortune.
.I
Water over wood: the image of the Well.
Thus the superior man encourages the people at their work,
And exhorts them to help one another.
.L 1 6
One does not drink the mud of the well.
No animals come to an old well.
.L 2 9
At the wellhole one shoots fishes.
The jug is broken and leaks.
.L 3 9
The well is cleaned, but no one drinks from it.
This is my heart's sorrow,
For one might draw from it.
If the king were clear-minded,
Good fortune might be enjoyed in common.
.L 4 6
The well is being lined. No blame.
.L 5 9 G
In the well there is a clear, cold spring
From which one can drink.
.L 6 6
One draws from the well
Without hindrance.
It is dependable.
Supreme good fortune.
.H 49 "Ko" "Revolution (Molting)"
.X 5 3
.J
Revolution. On your own day
You are believed.
Supreme success,
Furthering through perseverance.
Remorse disappears.
.I
Fire in the lake: the image of Revolution.
Thus the superior man
Sets the calendar in order
And makes the seasons clear.
.L 1 9
Wrapped in the hide of a yellow cow.
.L 2 6
When one's own day comes, one may create revolution.
Starting brings good fortune. No blame.
.L 3 9
Starting brings misfortune.
Perseverance brings danger.
When talk of revolution has gone the rounds three times,
One may commit himself,
And men will believe him.
.L 4 9
Remorse disappears. Men believe him.
Changing the form of government brings good fortune.
.L 5 9 G
The great man changes like a tiger.
Even before he questions the oracle
He is believed.
.L 6 6
The superior man changes like a panther.
The inferior man molts in the face.
Starting brings misfortune.
To remain persevering brings good fortune.
.H 50 "Ting" "The Caldron"
.X 3 2
.J
The Caldron. Supreme good fortune.
Success.
.I
Fire over wood:
The image of the Caldron.
Thus the superior man consolidates his fate
By making his position correct.
.L 1 6
A \fIting\fR with legs upturned.
Furthers removal of stagnating stuff.
One takes a concubine for the sake of her son.
No blame.
.L 2 9
There is food in the \fIting\fR.
My comrades are envious,
But they cannot harm me.
Good fortune.
.L 3 9
The handle of the \fIting\fR is altered.
One is impeded in his way of life.
The fat of the pheasant is not eaten.
Once rain falls, remorse is spent.
Good fortune comes in the end.
.L 4 9
The legs of the \fIting\fR are broken.
The prince's meal is spilled
And his person is soiled.
Misfortune.
.L 5 6 G
The \fIting\fR has yellow handles, golden carrying rings.
Perseverance furthers.
.L 6 9 G
The \fIting\fR has rings of jade.
Great good fortune.
Nothing that would not act to further.
.H 51 "Ch\o'^e'n" "The Arousing (Shock, Thunder)"
.X 7 7
.J
Shock brings success.
Shock comes\(emoh, oh!
Laughing words\(emha, ha!
The shock terrifies for a hundred miles,
And he does not let fall the sacrificial spoon and chalice.
.I
Thunder repeated: the image of Shock.
Thus in fear and trembling
The superior man sets his life in order
And examines himself.
.L 1 9 G
Shock comes\(emoh, oh!
Then follow laughing words\(emha, ha!
Good fortune.
.L 2 6
Shock comes bringing danger.
A hundred thousand times
You lose your treasures
And must climb the nine hills.
Do not go in pursuit of them.
After seven days you will get them back.
.L 3 6
Shock comes and makes one distraught.
If shock spurs to action
One remains free of misfortune.
.L 4 9
Shock is mired.
.L 5 6
Shock goes hither and thither.
Danger.
However, nothing at all is lost.
Yet there are things to be done.
.L 6 6
Shock brings ruin and terrified gazing around.
Going ahead brings misfortune.
If it has not yet touched one's own body
But has reached one's neighbor first,
There is no blame.
One's comrades have something to talk about.
.H 52 "K\o'^e'n" "Keeping Still, Mountain"
.X 4 4
.J
Keeping Still. Keeping his back still
So that he no longer feels his body.
He goes into his courtyard
And does not see his people.
No blame.
.I
Mountains standing close together:
The image of Keeping Still.
Thus the superior man
Does not permit his thoughts
To go beyond his situation.
.L 1 6
Keeping his toes still.
No blame.
Continued perseverance furthers.
.L 2 6
Keeping his calves still.
He cannot rescue him whom he follows.
His heart is not glad.
.L 3 9
Keeping his hips still.
Making his sacrum stiff.
Dangerous. The heart suffocates.
.L 4 6
Keeping his trunk still.
No blame.
.L 5 6
Keeping his jaws still.
The words have order.
Remorse disappears.
.L 6 9 G
Noblehearted keeping still.
Good fortune.
.H 53 "Chien" "Development (Gradual Progress)"
.X 2 4
.J
Development. The maiden
Is given in marriage.
Good fortune.
Perseverance furthers.
.I
On the mountain, a tree:
The image of Development.
Thus the superior man abides in dignity and virtue,
In order to improve the mores.
.L 1 6
The wild goose gradually draws near the shore.
The young son is in danger.
There is talk. No blame.
.L 2 6 G
The wild goose gradually draws near the cliff.
Eating and drinking in peace and concord.
Good fortune.
.L 3 9
The wild goose gradually draws near the plateau.
The man goes forth and does not return.
The woman carries a child but does not bring it forth.
Misfortune.
It furthers one to fight off robbers.
.L 4 6
The wild goose gradually draws near the tree.
Perhaps it will find a flat branch. No blame.
.L 5 9 G
The wild goose gradually draws near the summit.
For three years the woman has no child.
In the end nothing can hinder her.
Good fortune.
.L 6 9
The wild goose gradually draws near the cloud heights.
Its feathers can be used for the sacred dance.
Good fortune.
.H 54 "Kuei Mei" "The Marrying Maiden"
.X 7 5
.J
The Marrying Maiden.
Undertakings bring misfortune.
Nothing that would further.
.I
Thunder over the lake:
The image of the Marrying Maiden.
Thus the superior man
Understands the transitory
In the light of the eternity of the end.
.L 1 9
The marrying maiden as a concubine.
A lame man who is able to tread.
Undertakings bring good fortune.
.L 2 9
A one-eyed man who is able to see.
The perseverance of a solitary man furthers.
.L 3 6 C
The marrying maiden as a slave.
She marries as a concubine.
.L 4 9
The marrying maiden draws out the allotted time.
A late marriage comes in due course.
.L 5 6 G
The sovereign I gave his daughter in marriage.
The embroidered garments of the princess
Were not as gorgeous
As those of the servingmaid.
The moon that is nearly full
Brings good fortune.
.L 6 6 C
The woman holds the basket, but there are no fruits in it.
The man stabs the sheep, but no blood flows.
Nothing that acts to further.
.H 55 "F\o'^e'ng" "Abundance [Fullness]"
.X 7 3
.J
Abundance has success.
The king attains abundance.
Be not sad.
Be like the sun at midday.
.I
Both thunder and lightning come:
The image of Abundance.
Thus the superior man decides lawsuits
And carries out punishments.
.L 1 9
When a man meets his destined ruler,
They can be together ten days,
And it is not a mistake.
Going meets with recognition.
.L 2 6
The curtain is of such fullness
That the polestars can be seen at noon.
Through going one meets with mistrust and hate.
If one rouses him through truth,
Good fortune comes.
.L 3 9
The underbrush is of such abundance
That the small stars can be seen at noon.
He breaks his right arm. No blame.
.L 4 9
The curtain is of such fullness
That the polestars can be seen at noon.
He meets his ruler, who is of like kind.
Good fortune.
.L 5 6 G
Lines are coming,
Blessing and fame draw near.
Good fortune.
.L 6 6
His house is in a state of abundance.
He screens off his family.
He peers through the gate
And no longer perceives anyone.
For three years he sees nothing.
Misfortune.
.H 56 "Lu" "The Wanderer"
.X 3 4
.J
The Wanderer. Success through smallness.
Perseverance brings good fortune
To the wanderer.
.I
Fire on the mountain:
The image of the Wanderer.
Thus the superior man
Is clear-minded and cautious
In imposing penalties,
And protracts no lawsuits.
.L 1 6
If the wanderer busies himself with trivial things,
He draws down misfortune upon himself.
.L 2 6
The wanderer comes to an inn.
He has his property with him.
He wins the steadfastness of a young servant.
.L 3 9
The wanderer's inn burns down.
He loses the steadfastness of his young servant.
Danger.
.L 4 9
The wanderer rests in a shelter.
He obtains his property and an ax.
My heart is not glad.
.L 5 6 G
He shoots a pheasant.
It drops with the first arrow.
In the end this brings both praise and office.
.L 6 9
The bird's nest burns up.
The wanderer laughs at first,
Then must needs lament and weep.
Through carelessness he loses his cow.
Misfortune.
.H 57 "Sun" "The Gentle (The Penetrating, Wind)"
.X 2 2
.J
The Gentle. Success through what is small.
It furthers one to have somewhere to go.
It furthers one to see the great man.
.I
Winds following one upon the other:
The image of the Gently Penetrating.
Thus the superior man
Spreads his commands abroad
And carries out his undertakings.
.L 1 6 C
In advancing and in retreating,
The perseverance of a warrior furthers.
.L 2 9
Penetration under the bed.
Priests and magicians are used in great number.
Good fortune. No blame.
.L 3 9
Repeated penetration. Humiliation.
.L 4 6 C
Remorse vanishes.
During the hunt
Three kinds of game are caught.
.L 5 9 G
Perseverance brings good fortune.
Remorse vanishes.
Nothing that does not further.
No beginning, but an end.
Before the change, three days.
After the change, three days.
Good fortune.
.L 6 9
Penetration under the bed.
He loses his property and his ax.
Perseverance brings misfortune.
.H 58 "Tui" "The Joyous, Lake"
.X 5 5
.J
The Joyous. Success.
Perseverance is favorable.
.I
Lakes resting one on the other:
The image of the Joyous.
Thus the superior man joins with his friends
For discussion and practice.
.L 1 9
Contented joyousness. Good fortune.
.L 2 9 G
Sincere joyousness. Good fortune.
Remorse disappears.
.L 3 6 C
Coming joyousness. Misfortune.
.L 4 9
Joyousness that is weighed is not at peace.
After ridding himself of mistakes a man has joy.
.L 5 9 G
Sincerity toward disintegrating influences is dangerous.
.L 6 6 C
Seductive joyousness.
.H 59 "Huan" "Dispersion [Dissolution]"
.X 2 6
.J
Dispersion. Success.
The king approaches his temple.
It furthers one to cross the great water.
Perseverance furthers.
.I
The wind drives over the water:
The image of Dispersion.
Thus the kings of old sacrificed to the Lord
And built temples.
.L 1 6
He brings help with the strength of a horse.
Good fortune.
.L 2 9 C
At the dissolution
He hurries to that which supports him.
Remorse disappears.
.L 3 6
He dissolves his self. No remorse.
.L 4 6 C
He dissolves his bond with his group.
Supreme good fortune.
Dispersion leads in turn to accumulation.
This is something that ordinary men do not think of.
.L 5 9 G
His loud cries are as dissolving as sweat.
Dissolution. A king abides without blame.
.L 6 9
He dissolves his blood.
Departing, keeping at a distance, going out,
Is without blame.
.H 60 "Chieh" "Limitation"
.X 6 5
.J
Limitation. Success.
Galling limitation must not be persevered in.
.I
Water over lake: the image of Limitation.
Thus the superior man
Creates number and measure,
And examines the nature of virtue and correct conduct.
.L 1 9
Not going out of the door and the courtyard
Is without blame.
.L 2 9
Not going out of the gate and the courtyard
Brings misfortune.
.L 3 6
He who knows no limitation
Will have cause to lament.
No blame.
.L 4 6
Contented limitation. Success.
.L 5 9 G
Sweet limitation brings good fortune.
Going brings esteem.
.L 6 6
Galling limitation.
Perseverance brings misfortune.
Remorse disappears.
.H 61 "Chung Fu" "Inner Truth"
.X 2 5
.J
Inner Truth. Pigs and fishes.
Good fortune.
It furthers one to cross the great water.
Perseverance furthers.
.I
Wind over lake: the image of Inner Truth.
Thus the superior man discusses criminal cases
In order to delay executions.
.L 1 9
Being prepared brings good fortune.
If there are secret designs, it is disquieting.
.L 2 9
A crane calling in the shade.
Its young answers it.
I have a good goblet.
I will share it with you.
.L 3 6 C
He finds a comrade.
Now he beats the drum, now he stops.
Now he sobs, now he sings.
.L 4 6 C
The moon nearly at the full.
The team horse goes astray.
No blame.
.L 5 9 G
He possesses truth, which links together.
No blame.
.L 6 9
Cockcrow penetrating to heaven.
Perseverance brings misfortune.
.H 62 "Hsiao Kuo" "Preponderance of the Small"
.X 7 4
.J
Preponderance of the Small. Success.
Perseverance furthers.
Small things may be done; great things should not be done.
The flying bird brings the message:
It is not well to strive upward,
It is well to remain below.
Great good fortune.
.I
Thunder on the mountain:
The image of Preponderance of the Small.
Thus in his conduct the superior man gives preponderance to reverence.
In bereavement he gives preponderance to grief.
In his expenditures he gives preponderance to thrift.
.L 1 6
The bird meets with misfortune through flying.
.L 2 6 G
She passes by her ancestor
And meets her ancestress.
He does not reach his prince
And meets the official.
No blame.
.L 3 9
If one is not extremely careful,
Somebody may come up from behind and strike him.
Misfortune.
.L 4 9
No blame. He meets him without passing by.
Going brings danger. One must be on guard.
Do not act. Be constantly persevering.
.L 5 6 G
Dense clouds,
No rain from our western territory.
The prince shoots and hits him who is in the cave.
.L 6 6
He passes him by, not meeting him.
The flying bird leaves him.
Misfortune.
This means bad luck and injury.
.H 63 "Chi Chi" "After Completion"
.X 6 3
.J
After Completion. Success in small matters.
Perseverance furthers.
At the beginning good fortune,
At the end disorder.
.I
Water over fire: the image of the condition
In After Completion.
Thus the superior man
Takes thought of misfortune
And arms himself against it in advance.
.L 1 9
He brakes his wheels.
He gets his tail in the water.
No blame.
.L 2 6 G
The woman loses the curtain of her carriage.
Do not run after it;
On the seventh day you will get it.
.L 3 9
The Illustrious Ancestor
Disciplines the Devil's Country.
After three years he conquers it.
Inferior people must not be employed.
.L 4 6
The finest clothes turn to rags.
Be careful all day long.
.L 5 9
The neighbor in the east who slaughters an ox
Does not attain as much real happiness
As the neighbor in the west
With his small offering.
.L 6 6
He gets his head in the water. Danger.
.H 64 "Wei Chi" "Before Completion"
.X 3 6
.J
Before Completion. Success.
But if the little fox, after nearly completing the crossing,
Gets his tail in the water,
There is nothing that would further.
.I
Fire over water:
The image of the condition before transition.
Thus the superior man is careful
In the differentiation of things,
So that each finds its place.
.L 1 6
He gets his tail in the water.
Humiliating.
.L 2 9
He brakes his wheels.
Perseverance brings good fortune.
.L 3 6
Before completion, attack brings misfortune.
It furthers one to cross the great water.
.L 4 9
Perseverance brings good fortune.
Remorse disappears.
Shock, thus to discipline the Devil's Country.
For three years, great realms are awarded.
.L 5 6 G
Perseverance brings good fortune.
No remorse.
The light of the superior man is true.
Good fortune.
.L 6 9
There is drinking of wine
In genuine confidence. No blame.
But if one wets his head,
He loses it, in truth.
