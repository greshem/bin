#!/usr/bin/perl
#
our $logtmp="logtmp.txt";
system("svn log >logtmp.txt");

#system("cp mfclog.txt $logtmp");  

log_filter();
 
sub log_filter()
{
	my($num,$bprint,@array);
	open(FILE, $logtmp)  or die("Open file error\n");
	while(<FILE>)
	{
		if(/.*----------------------------------------------.*/)
		{
			if($bprint==1)
			{
				 print(@array);
				 $bprint=0;
			}
			 @array=();
		}
		push(@array,$_); 
		if(/[add|mdf|ref|chg|bug]_(\d+)([m|h])/i)
		{
			if(($1>=15)or($2 eq 'h')) #花费的时间.
			{
				$bprint=1;
			}
		}
	}
	close(FILE);
	unlink($logtmp);
}
