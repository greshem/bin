#!/usr/bin/perl
 use String::Similarity;
#use ANSI::Color;
use Term::ANSIColor;
if (scalar(@ARGV) != 1)
{
	printf "./str_cmp_similirity.pl list\n";
	exit(-1);

}
	
#print "BEGIN to do\n";
open(DATA, $ARGV[0]) or die("open file error\n");
	@word=<DATA>;
 for ($i=0;$i< $#word; $i++)
 {

	 $similarity = similarity $word[$i], $word[$i+1];
	 chomp($word[$i]);
	 #print $word[$i];
	 #$diff_word=
	 #print  "diff word=" , (1-$similarity)*(length($word[$i])>length($word[$i+1])?length($word[$i]):length($word[$i+1])),"\n";
	 $diff_word= (1-$similarity)*(length($word[$i])>length($word[$i+1])?length($word[$i]):length($word[$i+1]));
	 $diff_word=int ($diff_word);
	#不同的单词操作 8个. 
	if ($diff_word > 8)
	# if ($similarity < 0.7)
	{
		#	print color "red";
		print $word[$i],"\n";
		#	print "             ##Diff_word ",$diff_word,"\n";
		#	print color "reset";
	}
	else
	{
	#	print $word[$i];
	#	print "             ##Diff_word  ",$diff_word,"\n";

	}
 
}
