#!/usr/bin/perl -w

use strict;

use Getopt::Std;

use vars qw($VERSION);
$VERSION = q$Revision: 1.1 $ =~ /Revision:\s*(\S*)/;

use vars qw($opt_b $opt_f $opt_p $opt_x $opt_l);
use vars qw($opt_e $opt_E $opt_s $opt_t);

$opt_f = 0;

getopts('bfpxl:eEst') || die "Bad options.\n";

if ($opt_l and $opt_l !~ /\D/) {
    # multiply by 2 for half-lines
    $opt_l *= 2;
} else {
    $opt_l = 512;
}

my @buf = [];       # character buffer
my $col = 0;        # current column number
my $row = 0;        # current row number
my $max_row = -2;   # max populated row
my $iset = 1;       # current input character set (1 or 2)

my $oset = 1;       # current output character set (1 or 2)
my $front = 0;      # note whether at front of line in output
my $spaces = '';    # save spaces for converting to tabs

# prepare regexes for matching linefeeds
#                    any          full reverse  half reverse  half forward
my @re;
if ($opt_E) {
    # as for IRIX
    @re = qw(       [7-9]           ^7$           ^8$           ^9$       );
} elsif ($opt_e) {
    # as for BSD
    @re = qw(       [\x07-\x09]     ^\x07$        ^\x08$        ^\x09$    );
} else {
    # accept either
    @re = qw(       [7-9\x07-\x09]  ^[7\x07]$     ^[8\x08]$     ^[9\x09]$ );
}


# INPUT

while (<>) {
    # chop trailing characters not followed by a linefeed of any kind
    if ($opt_t) {
        $_ =~ s/^(.*(?:\x0A|\e$re[0])|).*$/$1/sxo;
    }

    my @chars = split m//;

    my $i;
    for ($i=0; $i<=$#chars; ++$i) {
        my $c = $chars[$i];

        if ($c eq "\x1B" or $c eq "\x0B") {
            if ($c eq "\x0B" or $chars[++$i] =~ /$re[1]/xo) {
                                                # reverse line feed
                $row -= 2;
                $row >= 0 or $row = 0;
            } elsif ($chars[$i] =~ /$re[2]/xo) { # half reverse line feed
                $row -= 1;
                $row >= 0 or $row = 0;
            } elsif ($chars[$i] =~ /$re[3]/xo) { # half forward line feed
                $row += 1;
            } else {                            # unrecognized escape
                if ($opt_p) {
                    add_char("\x1B");
                    add_char($chars[$i]);
                } else {
                }
            }
        } elsif ($c eq "\x08") {                # backspace
            $col--;
            $col >= 0 or $col = 0;
        } elsif ($c eq "\x0D") {                # carriage return
            $col = 0;
        } elsif ($c eq "\x0A") {                # line feed
            $row += 2;
            $col = 0;
        } elsif ($c eq "\x0F") {                # shift in
            $iset = 1;
        } elsif ($c eq "\x0E") {                # shift out
            $iset = 2;
        } elsif ($c eq "\x20") {                # space
            $col++;
        } elsif ($c eq "\x09") {                # tab
            $col += (($col % 8) || 8);
        } elsif ($c gt "\x20") {                # printable character
            add_char($c);
        } else {                                # unrecognized ctl char
        }

        # start row if necessary
        $buf[$row] ||= [];

        # check buffer size
        if (@buf > $opt_l) {
            print_line(0);

            if ($buf[1] and @{$buf[1]}) {
                # print next half line
                print "\e9";
                print "\x0D" if !$front;
                $front = 1;

                print_line(1);
                print "\e9";
                print "\x0D" if !$front;
                $front = 1;
            } else {
                # skip to next full line
                print "\x0A";
                $front = 1;
            }

            # splice off top two rows
            splice(@buf, 0, 2);
            $max_row -= 2;
        }

    }
}


# add_char
# add a character at the current row and column
# uses globals @buf, $row, $max_row, $col, $iset, $opt_f, $opt_b
sub add_char {
    my($char) = @_;

    # move to next full line, if necessary
    my $r = $row;
    if (!$opt_f) {
        $r += $row & 1;
        # start row if necessary
        $buf[$r] ||= [];
    }

    # start column if necessary
    $buf[$row][$col] ||= [];

    if ($opt_b) {
        # no backspacing - just save last character/set
        $buf[$r][$col][0] = [$char, $iset];
    } else {
        # backspacing - add character/set to end of list
        push @{$buf[$r][$col]}, [$char, $iset];
    }

    $col++;

    $max_row = $r if $r > $max_row;
}


# OUTPUT

# add a blank row if buffer does not end with one
if ($max_row == $#buf) {
    push @buf, [];
}

# add a blank row if buffer ends on half line
if ($#buf & 1) {
    push @buf, [];
}

for ($row=0; $row < $max_row; ) {
    # print the current line
    print_line($row);

    # print appropriate line ending
    if ($buf[$row+1] and @{$buf[$row+1]}) {
        # half line feed
        print "\e9";
        print "\x0D" if !$front;
        $front = 1;
    } else {
        # full line feed
        print "\x0A";
        # skip half line
        ++$row;
        $front = 1;
    }
    ++$row;
}

# print the last populated line ($row == $max_row)
print_line($row);

# shift in if necessary
if (!$opt_s) {
    if ($oset == 2) {
        print "\x0F";
        $oset = 1;
    }
}

# print linefeeds for remaining blank lines
for ($row++; $row < $#buf; $row += 2) {
    print "\x0A";
    $front = 1;
}

# print half line feed if necessary
if ($max_row & 1) {
    print "\e9";
    print "\x0D" if !$front;
    $front = 1;
}


# print_line
# print the current line
# return character set of the last character
# uses globals @buf, $oset, $front, $opt_x, $opt_s
sub print_line {
    my($row) = @_;
    my $char;

    if (@{$buf[$row]}) {
        $front = 0;
    }

    my $col;
    for ($col=0; $col<=$#{$buf[$row]}; ++$col) {

        if ($buf[$row][$col]) {

            if ($spaces) {
                # print saved spaces
                print $spaces;
                $spaces = '';
            }

            my $b;
            foreach $char (@{$buf[$row][$col]}) {
                # print backspace if necessary
                print "\x08" if $b++;

                # switch character set if necessary
                if ($char->[1] != $oset) {
                    $oset = $char->[1];
                    print ($oset == 1 ? "\x0F" : "\x0E");
                }

                # print character
                print $char->[0];
            }

        } else {
            # no characters; space

            if ($opt_x) {
                print ' ';
            } else {
                if (not (($col+1) % 8)) {
                    # at tab stop
                    print "\t";
                    $spaces = '';
                } else {
                    $spaces .= ' ';
                }
            }

        }

    }

    # switch to character set 1 for line ending
    if ($opt_s) {
        if ($oset == 2) {
            print "\x0F";
            $oset = 1;
        }
    }
}

exit 0;

__END__

=pod

=head1 NAME

B<col> -- filter reverse line feeds from input

=head1 SYNOPSIS

B<col> [B<-bfpx>] [B<-l num>] [B<-Eest>]

=head1 DESCRIPTION

B<col> filters out reverse (and half-reverse) line feeds so that the
output is in the correct order with only forward and half-forward line
feeds, and replaces whitespace characters with tabs where possible.
This can be useful in processing the output of nroff(1) and tbl(1).

B<col> reads from the standard input and writes to the standard output.

=head2 OPTIONS

B<col> accepts the following standard options:

=over 4

=item B<-b>

Do not output any backspaces, printing only the last character written
to each column position.

=item B<-f>

Forward half-line feeds are permitted ("fine" mode).  Without this
option, characters which would be printed on a half-line boundary are
printed on the following line.

=item B<-p>

Output unrecognized escape sequences.  Without this option,
unrecognized escape sequences are ignored.  Because escape sequences
may be overprinted from reverse line feeds, the use of this option is
highly discouraged unless the user is fully aware of the textual
position of the escape sequences.

=item B<-x>

Output multiple spaces instead of tabs.  Tab stops are eight
characters apart.

=item B<-l> I<num>

Buffer at least I<num> lines in memory.  By default 256 lines (or 512
half-lines) are buffered.

=back

B<col> also accepts the following options for compatibility with other
implementations:

=over 4

=item B<-E>

Accept only IRIX-style escape sequences; a reverse line feed is an
escape followed by the ASCII character 7.  The B<-E> option
overrides the B<-e> option.

=item B<-e>

Accept only BSD-style escape sequences; a reverse line feed is an
escape followed by the ASCII character whose decimal value is 7
(control-g).  The B<-e> option is overriden by the B<-E> option.

If neither the B<-E> nor the B<-e> option is used, B<col> accepts both BSD
and IRIX style escapes sequences.

=item B<-s>

Shift in before each line feed when in the alternate character set (as
in IRIX B<col>).  Without this option, B<col> only shifts in before
the final line endings (as in BSD B<col>).

=item B<-t>

Ignore trailing input that is not followed by a line feed (as in IRIX
B<col>).  Without this option, a final line feed is not necessary (as
in BSD B<col>.)

=back

The control sequences and their decimal ASCII values that col
understands are listed in the following table:

    ESC-7            Reverse line feed (escape then 7).
    ESC-8            Half reverse line feed (escape then 8).
    ESC-9            Half forward line feed (escape then 9).
    backspace        Moves back one column (8); ignored in the first column.
    carriage return  (13)
    newline          Forward line feed (10); also does carriage return.
    shift in         Shift to normal character set (15).
    shift out        Shift to alternate character set (14).
    space            Moves forward one column (32).
    tab              Moves forward to next tab stop (9).
    vertical tab     Reverse line feed (11).

(See the explanations of B<-e> and B<-E> for more about escapes and
line feeds.)

=head1 BUGS

This implementation of B<col> has no known bugs.

=head1 CAVEATS

Reverse line feeds and half reverse line feeds which would move past
the start of the buffer are ignored.

Unrecognized control characters are ignored.

Unrecognized escape sequences are ignored, unless the B<-p> option is used.

Some versions of B<col> for BSD may convert spaces to tabs
incorrectly.  This implementation of B<col> does not emulate that bug.

This implementation of B<col> was compared to the B<col> utility on
IRIX and BSD, and includes compatibility modes for both those systems.
The B<col> utilities on other systems may have further differences in
behavior.

=head1 REVISION HISTORY

    $Log: col,v $
    Revision 1.1  2004/08/05 14:17:43  cwest
    cleanup, new version number on website

    Revision 1.3  2003/06/06 03:44:01  rjk
    updates to POD
    new email address

    Revision 1.2  2001/04/11 03:54:36  rjk
    avoid POD warnings for bare -E, etc.

    Revision 1.1  2000/02/12 15:46:03  rjk
    Initial revision


=head1 AUTHOR

This implementation of B<col> in Perl was written by Ronald J Kimball,
I<rjk-perl@tamias.net>

=head1 COPYRIGHT and LICENSE

This program is copyright 2000 by Ronald J Kimball.

This program is free and open software.  You may use, modify, or
distribute this program (and any modified variants) in any way you
wish, provided you do not restrict others from doing the same.

=cut

