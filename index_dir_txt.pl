#!/usr/bin/perl 
#@ARGV or die("$0 file\n");
opendir(DIR,".") or die("open dir error\n");
@files=grep { -f  && /txt$/} readdir(DIR);
	%words={};
for(@files)
{
	print STDERR  "deal with $_\n";
	open(FILE, "$_");
	while(<FILE>)
	{
		chomp;
		@array=split(/\s+/, $_);
		for $word (@array)
		{
		
			next if(/\d:/);
	#		$word=~tr/A-Z/a-z/;
			$word=~ s/\ |\'|\`|\(|[\}|\"|\:|\;|\.|\]|\?|\,|\!|\)|\']{1,}$//;
			$word=~s/\"|\ |\'|\`|\(|^[\}|\"|\:|\;|\.|\]|\?|\,|\!|\)|\']{1,}//;
			

			if($words{$word})
			{
			 $words{$word}++; #,"\n";
			}
			else
			{
			 $words{$word}=1; #,"\n";
			}
		}
	}
	close(FILE);
}
open(OUTPUT, ">frequency.list");
for( sort {$words{$a}<=> $words{$b}} keys %words)
{
	print OUTPUT $_,"    ->", $words{$_},"\n";
}
close(OUTPUT);
