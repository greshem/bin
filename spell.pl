#!/usr/bin/perl -w

use strict;

my $dict_file = "/usr/dict/words";      # Filename (path) for standard dict
my $alt_dict_file = "/usr/dict/linux.words"; # Filename (path) for an alternate dict

my (
    %words,    # words from dictionary
    %check,    # words to be checked
    @supp,     # file(s) of supplemental dictionaries/words
    @files,    # file(s) to check
    @keys,     # keys of the %words hash
    $check,    # Indicator if close matches should be found
    $inter,    # Indicator if in "interactive mode
    $suff,     # Indicator if suffixes should be checked
);

sub usage {
  warn "$0: @_\n" if @_;
  die "usage: $0 [-b[dict]] [-c|-x] [-v] [-i] [-s dict] [ file ... ]\n";  
}

# usage() unless @ARGV;

keys %words = 45402;   # allocate bins for the hash, it may be useful to 
                       #  change this if you dict file is larger or smaller.

# process command line args
while (@ARGV) {
  $_ = $ARGV[0];
  if (s/^-//) {
    if (s/^b//) {
      if (length) { $dict_file = $_ }
      else { $dict_file = $alt_dict_file }
    }
    elsif (s/^[cx]//) {
      $check++;
      if (length) {
	$ARGV[0] = "-$_";
	redo;
      }
    }
    elsif (s/^v//) {
      $suff++;
      if (length) {
	$ARGV[0] = "-$_";
	redo;
      }
    }
    elsif (s/^i//) {
      $inter++;
      if (length) {
	$ARGV[0] = "-$_";
	redo;
      }
    }
    elsif (s/^s//) {
      if (length) { push @supp, $_ }
      else { push @supp, $ARGV[1]; shift}
    }
    else {
      usage("unrecognized option: -$_");
    }
  }
  else {   # must be the file(s) to check.
    push @files, $_;
  }
  shift;
}

unshift @supp, $dict_file;  

# read in dictionary words

for my $dict_file (@supp) {
  open(IN,$dict_file) || die "Could not open dictionary <$dict_file>: $!\n";
  my @tmp_words;
  @tmp_words = map {lc} <IN>;
  chomp @tmp_words;
  @words{@tmp_words} = ();

#  for my $word (@tmp_words) {
#    $words{lc($word)} = 1;
#  } 
}

@keys = keys %words;

# Read data to check

@ARGV = @files;

if ($inter) {
  print "Word(s): ";
}

while (<>) {
  chomp;
  last if /^\s*$/ && $inter;
  $_ = lc $_;
  my @tmp_words =grep {/[^\W\d_]/} split;
  for (@tmp_words) {
    s/^[\W_]+//;      # strip out punctuation, etc.
    s/[\W\d_]+$//;
    $check{$_}++;
  }
  if ($inter) {
    check_words( keys %check );
    %check=();
    print "Word(s): ";
  }
}

unless ( $inter ) {
  check_words( keys %check );
}

exit 0;  # end of main program, below are subroutines.

sub check_words {

  my @check = sort grep { !exists($words{$_}) } @_ ;
  my @suffs; 
  my $temp;

  for my $orig ( @check ) {
    $temp = suffix($orig);
    if ($temp) {
      push @suffs, $temp;
      undef $orig;
    }
  }

  if ($inter) {
    print 'Found: '. join(', ', grep { exists($words{$_}) } @_ );

    if ($suff) { # show suffix changes.
      print "\n\nClose Matches:\n";
      for (@suffs) {
	more( "  $_\n");
      }
    }

    print "\n\nNot Found:\n\n";
    for (@check) {
      next unless $_;
      more( "   $_.\n" );
      
      if ($check) {
	more( "-----\n" );
	for (&close($_)) {
	  more( "    $_\n");
	}
	more("\n");
      }
    }
  }
  else {

    if ($suff) { # show suffix changes.
      for (@suffs) {
	print "$_\n";
      }
      print "\n-----\n\n";
    }
    
    for (@check) {
      next unless $_;
      print $_."\n";
      if ($check) {
	print "-----\n  ".join("\n  ",&close($_))."\n\n";
      }
    }
  }

}

sub close {
  my $word = shift;
  my %close;
  my ($first, $last, $mid, $mid2);

  # delete 1 char
  $first=$word;
  $last='';
  
  while( $mid=chop($first) ){
    if (exists($words{$first.$last})) {
      $close{$first.$last}=1;
    }
    $last=$mid.$last;
  }

  # add 1 char
  $first=$word;
  $last='';

  while ( $mid=chop($first) ) {
    $last = $mid.$last;
    my $temp = $first.'.'.$last;
    @close{ grep {/^$temp$/} @keys } = 1;
  }
  @close{ grep {/^$word/} @keys } = 1;

  # change 1 char
  $first=$word;
  $last='';

  while ( $mid=chop($first) ) {
    my $temp = $first.'.'.$last;
    @close{ grep {/^$temp$/} @keys } = 1;
    $last = $mid.$last;
  }

  # swap 2 chars
  $first=$word;
  $last='';
  $mid=chop($first);

  while ( $mid2=chop($first) ) {
    if ( exists($words{ $first.$mid.$mid2.$last }) ) {
      $close{ $first.$mid.$mid2.$last } =1;
    }
    $last = $mid.$last;
    $mid=$mid2;
  }

  return sort keys %close;
}

{
  my $line;
  sub more {
    if ( ++$line > 20 ) {
      print "----- MORE -----";
      scalar <>;
      print "\b"x16;
      $line=0;
    }
    print $_[0];
  }

}

sub suffix {

# This sub handles suffixes (i.e. the word is not in the dictionary,
# but the version without a suffix is.  It returns a string
# representing the difference between the original word and the
# dictionary word, or undef if no such words are found.

# some improvements needed: move the substitution into the if clause,
# so that the word isn't looked for if $word==$orig, put suffixes in
# an array and do this with a loop instead of separate ifs, optimize
# check order.

    #  with the better dictionary (better in my opinion, yours may
    #  vary), this is mostly commented out and the above fixes realy
    #  not needed.
  
  my $orig = shift;
  my $word;
  ($word = $orig ) =~ s/'s$//;    #';
  if (exists($words{$word})) {
    return qq("$orig" = "$word"  +  "'s");
  }
  if ( $orig =~ /^(\d+-?)(\w+)$/ && exists($words{$2})) {
    return qq("$orig" = "$1"  +  "$2");
  }
  if ( $orig =~ /^(\w+)-(\w+)$/ && exists($words{$1}) && exists($words{$2}) ) {
    return qq("$orig" = "$1"  +  "-"  +  "$2");
  }

# The suffixes below are from an earlier version, using a smaller
# words file.  If your words file does not contain many of the words
# that end with the below suffixes (but does contain the base), then
# uncomment the appropriate statements.

# ($word = $orig ) =~ s/ing$//;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" + "ing"); 
# }
# ($word = $orig ) =~ s/ing$/e/;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" - "e" + "ing");
# }
# ($word = $orig ) =~ s/ive$/e/;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" - "e" + "ive");
# }
# ($word = $orig ) =~ s/ed$//;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" + "ed");
# }
# ($word = $orig ) =~ s/d$//;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" + "d");
# }
# ($word = $orig ) =~ s/es$//;  
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" + "es");
# }
# ($word = $orig ) =~ s/s$//;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" + "s");
# }
# ($word = $orig ) =~ s/ies$/y/;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" - "y" + "ies");
# }
# ($word = $orig ) =~ s/ly$//;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" + "ly");
# }
# ($word = $orig ) =~ s/er$//;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" + "er");
# }
# ($word = $orig ) =~ s/or$//;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" + "or");
# }
# ($word = $orig ) =~ s/ion$//;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" + "ion");
# }
# ($word = $orig ) =~ s/ion$/e/;
# if (exists($words{$word})) {
#   return qq("$orig" = "$word" - "e" + "ion");
# }

  return undef;

}

__END__

=head1 NAME

spell - scan a file for misspelled words

=head1 SYNOPSIS

B<spell> 
[ B<-b>[I<dict>]]
[B<-c>|B<-x>]
[B<-v>]
[B<-i>]
[B<-s> I<dict>]
[ I<file> ... ]

=head1 DESCRIPTION

I<spell> reads in a file and splits it into words, then compares each
unique word with a dictionary file (all comparisons and reporting are
done in lower case).  The "misspelled" words are printed on standard
output.

The options are as follows:

=over 4

=item B<-b>

Use alternate dictionary (as specified in the variable at the top of
the script, you should change this to represent your system).

=item B<-b>I<file>

Use I<file> as the alternate dictionary (notice no space between flag
and I<file>).  This file is used B<instead of> the standard
dictionary.  This could be a British spelling list, or for a different
language.

=item B<-c>

Check the dictionary for "close" matches.
Each misspelled word will be followed by a list of indented close
matches.  A close match is one where it matches a word in the
dictionary if 1 character is deleted, or 1 letter is added, or any 2
adjacent characters are swapped.

=item B<-x>

Same as B<-c> above.

=item B<-v>

Show suffix expansion.  Some words are inferred by modifying 
words in the dictionary, this shows you how that was done on some of
your words, so you can double check if it did it right.

=item B<-i>

Use interactively.  Prompts for words, processes words after 
each line, instead of after whole file(s), and quit at first blank line
(do not use on a file, this is for typing in words from standard in).  
Also prints descriptive titles and has a very basic pager.

=item B<-s> I<file>

Specify supplemental dictionary.  This dictionary is used 
in addition to the base word list.  The space before the I<file> is 
optional.  Multiple files can be used, but each needs its own B<-s> flag.

=back

Multiple flags can be combined, but B<-b> and B<-s> must come last, i.e. 
"spell -icvb" instead of "spell -i -c -v -b", and can be specified in any
order.

If a file is not specified, it reads from standard input.  Use the B<-i> switch
if you are going to type words in by hand.

=head1 SEE ALSO

ispell

/usr/dict/words

I did not create a word list, but found one without restriction
(compiled for linux) at: C<ftp://ftp.cs.unc.edu/pub/users/faith/linux/linux.words.2.tar.gz>.

=head1 RESTRICTIONS

This program is only as good as your word list (and maybe not that
good, use the B<-v> switch at least once).  I did not compile the word
list and cannot vouch for it.  Remember this is a tool and not a
replacement for your own thinking.  Anyone who depends wholly on a
spell checker without doing their own proofreading, deserves what they
get (or worse), I accept no liability for any consequences of using
this program.

This program only finds the misspelled words, it is up to you to
decide if they are really wrong and replace them yourself.

My focus in writing this program was portability, therefore I did not
use some things that may have speeded things up, however perl itself
is quick enough that it still does pretty good even with the slower
method.

=head1 BUGS

I know of no bugs at this time.  There are a couple of things that may
make it run a bit faster and the documentation may be made a little clearer.

=head1 AUTHOR

Gregory L. Snow, (Greg), I<snow@biostat.washington.edu>

=head1 COPYRIGHT and LICENSE

This program is copyright (c) Gregory L. Snow 1999.

This program is free and open software.  You may use, modify, or
distribute this program (with or without modifications) to your hearts
content.  However I take no responsibility for your use or misuse of this program.


