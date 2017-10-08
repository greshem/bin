#!/usr/bin/perl
use Lingua::Stem qw(stem);

$stemmer=Lingua::Stem->new(-locale=>"EN-UK");

$word=$stemmer->stem(@ARGV);
for(0..$#ARGV)
{
	print $ARGV[$_],"--->", $word->[$_],"\n";
}

