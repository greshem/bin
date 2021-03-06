#!/usr/bin/perl -w

#
# $Id: moo,v 1.2 2004/08/05 14:17:43 cwest Exp $
#
# $Log: moo,v $
# Revision 1.2  2004/08/05 14:17:43  cwest
# cleanup, new version number on website
#
# Revision 1.1  2004/07/23 20:10:12  cwest
# initial import
#
# Revision 1.1  1999/02/28 14:28:46  abigail
# Initial revision
#
#

use strict;

my ($VERSION) = '$Revision: 1.2 $' =~ /([.\d]+)/;

# Print a usuage message on a unknown option.
$SIG {__WARN__} = sub {
    require File::Basename;
    $0 = File::Basename::basename ($0);
    if (substr ($_ [0], 0, 14) eq "Unknown option" ||
        substr ($_ [0], 0,  5) eq "Usage") {
        warn <<EOF;
$0 (Perl bin utils) $VERSION
$0 [size]
EOF
        exit 1;
    }
    else {
        warn "$0: @_";
    }
};

$SIG {__DIE__} = sub {
    require File::Basename;
    $0 = File::Basename::basename ($0);
    die "$0: @_";
};

my $size = 4;

warn "Usage" if @ARGV > 1;  # Will exit.

if (@ARGV) {
    $size = shift;
    warn "Usage" if !$size || $size =~ /\D/;  # Will exit;
}

print "MOO\n";
{
    my   @secret_by_value = (0) x 10;
    map {$secret_by_value [$_] ++} my @secret = map {int rand 10} 1 .. $size;

    my $attempts = 0;

    print "New game\n";

    {
        print "Your guess? ";
        chomp (my $guess = <>);

        exit if 'q' eq substr lc $guess, 0, 1;

        if ($guess =~ /\D/ || length $guess != $size) {
            print "Bad guess\n";
            redo
        }

        ++ $attempts;

        my @guess = split // => $guess;

        # Count the number of bulls and cows. We need a copy of
        # @secret_by_value for that.
        my $bulls = 0;
        my $cows  = 0;
        my @cows  = @secret_by_value;

        # We have to count the bulls before counting the cows.
        for (my $i = 0; $i < @guess; $i ++) {
            if ($secret [$i] == $guess [$i]) {
                $bulls ++;
                $cows [$guess [$i]] -- if $cows [$guess [$i]];
            }
        }

        for (my $i = 0; $i < @guess; $i ++) {
            next if $secret [$i] == $guess [$i]; # Counted the bulls already.
            if ($cows [$guess [$i]]) {
                $cows [$guess [$i]] --;
                $cows ++;
            }
        }

        print "Bulls = $bulls\tCows = $cows\n";

        if ($bulls == $size) {
            # Won the game!
            print "Attempts = $attempts\n";
            last;
        }

        redo;
    }

    redo;
}

__END__

=pod

=head1 NAME

moo -- play a game of MOO

=head1 SYNOPSIS

moo [size]

=head1 DESCRIPTION

I<moo> is a game where the user has to guess a number choosen by
the computer. By default, the computer takes a number of four digits
(including 0's), but that can be changed by giving I<moo> the number of
digits to take.  After each guess, the number of B<bull>s and B<cow>s
is displayed.  A B<bull> is a correctly guessed digit, in the right
place, while a B<cow> is a correct digit, not in the right place. Once
a game has finished because all the digits have been guessed correctly,
a new game will be started. Exiting the program can be done by typing
'q' or 'Q' on a guess, or hitting the interrupt key (usually control-C).

=head2 OPTIONS

The only option I<moo> takes is optional, and is the number of digits to
use for the number to guess.

=head1 ENVIRONMENT

The working of I<moo> is not influenced by any environment variables.

=head1 BUGS

I<moo> does not have any known bugs.

=head1 REVISION HISTORY

    $Log: moo,v $
    Revision 1.2  2004/08/05 14:17:43  cwest
    cleanup, new version number on website

    Revision 1.1  2004/07/23 20:10:12  cwest
    initial import

    Revision 1.1  1999/02/28 14:28:46  abigail
    Initial revision

=head1 AUTHOR

The Perl implementation of I<moo> was written by Abigail, I<abigail@fnx.com>.

=head1 COPYRIGHT and LICENSE

This program is copyright by Abigail 1999.

This program is free and open software. You may use, copy, modify, distribute
and sell this program (and any modified variants) in any way you wish,
provided you do not restrict others to do the same.

=cut

