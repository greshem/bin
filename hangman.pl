#!/usr/bin/perl -w

use strict;

srand();
my( $cont ) = "y";
my( %in_word, %guess, @guess, @word, @disp_word );
my( $letter, $word, $x, $num_wrong, $tot_letters, $num_corr );

while( $cont =~ /^y/io ) {
	( %in_word, %guess, @disp_word ) = ();
	$word = &get_a_word();
	@word = split( / */, $word );
	for( $x = 0; $x <= $#word; $x++ ) {
		$disp_word[ $x ] = "_";
		$in_word{ $word[ $x ] } = 1;
	}
	$tot_letters = scalar( keys( %in_word ) );
	$num_wrong = 0;
	$num_corr = 0;
	&print_noose( $num_wrong, @disp_word );
	while( ($num_wrong < 6) && ($num_corr < $tot_letters) ) {
		print "\nEnter a letter:  ";
		$letter = <STDIN>;
		chomp( $letter );
		$letter = lc( $letter );
		if( $letter =~ /^[a-z]$/o ) {
			if(! exists( $guess{ $letter } ) ) {
				$guess{ $letter } = 1;
				if(! exists( $in_word{ $letter } ) ) {
					$num_wrong++;
				} else {
					$num_corr++;
					for( $x = 0; $x <= $#word; $x++ ) {
						if( $word[ $x ] eq $letter ) {
							$disp_word[ $x ] = $letter;
						}
					}
				}
			} else {
				print "\nYOU HAVE ALREADY GUESSED THAT LETTER.\n\n";
			}
		} else {
			print "\nPLEASE ENTER A SINGLE LETTER FROM A TO Z.\n\n";
		}
		&print_noose( $num_wrong, @disp_word );
		print "\nLetters Chosen:  ";
		@guess = sort( keys( %guess ) );
		print "@guess\n";
	}
	if( $num_wrong == 6 ) {
		print "\nYOU LOSE!\nThe word was \"$word\".\n";
	} else {
		print "\nYOU WIN!\n";
	}
	print "\nPlay Again (y/N)?  ";
	$cont = <STDIN>
}
print "\nTHANKS FOR PLAYING!\n";

sub get_a_word {
	my( $word );
	my( $line_num ) = 1;
	my( $random ) = rand();
	my( $val ) = int( $random * 9151 ) + 1;
	#open( FILE, "/usr/share/words/wordlist.txt" ) || die "$!, stopped";
	open( FILE, "/usr/share/dict/linux.words" ) || die "$!, stopped";
	while( <FILE> ) {
		if( $line_num == $val ) {
			$word = $_;
			chomp( $word );
			last;
		} else {
			$line_num++;
		}
	}
	close( FILE );
	return( $word );
}

sub print_noose {
	my( $num, @y ) = @_;
	my( $line_1 ) = "  +--+\n";
	my( $line_2 ) = "     |\n";
	my( $line_3 ) = "     |";
	my( $line_4 ) = "     |\n";
	my( $line_5 ) = "     |\n";
	my( $line_6 ) = " ----+\n";
	$line_2 = "  O  |\n" if( $num > 0 );
	$line_3 = "  |  |" if( $num > 1 );
	$line_3 = " /|  |" if( $num > 2 );
	$line_3 = " /|\\ |" if( $num > 3 );
	$line_4 = " /   |\n" if( $num > 4 );
	$line_4 = " / \\ |\n" if( $num > 5 );
	print "\n$line_1$line_2$line_3  @y\n$line_4$line_5$line_6";
}

# POD SECTION #

=head1 NAME

B<hangman> - perl version of the game hangman.  Part of the Perl Power Tools.

=head1 SYNOPSIS

B<hangman>

=head1 DESCRIPTION

In B<hangman>, the computer picks a word from the on-line, supplied word list,
and you must try and guess it.  The computer keeps track of which letters you
have chosen, displaying them on each pass, and how many wrong guesses you have
made, graphically displayed via the hangman's gallows.

=head1 FILES

F<wordlist.txt> - distributed with the program, and residing in the same
directory.

=head1 AUTHOR

Michael E. Schechter
mschechter@earthlink.net

=head1 COPYRIGHT INFORMATION

This application is distributed as part of the Perl Power Tools.  Feel free
to copy,
modify, delete, or whatever you would like with this file, under the
information
contained in the GNU GPL.

=cut
