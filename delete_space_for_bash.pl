#!/usr/bin/perl


if(grep{/dump/} @ARGV)
{
	print "g_pwd=\$(pwd)\n";
	for(1..12)
	{
		
		print "cd \$g_pwd\n";
		print "#####################################################################\n";
 		print "for each in  \$( find \$(pwd)  -type d -mindepth  $_ -maxdepth $_) \n";
		print "do \n";
		print "echo  \$each   \n";
		print "cd \$each   \n";
		print "delete_space_for_bash.pl \n";
		print "done\n";
	}
	exit(0);;
}
foreach $each (<*>)
{
	$tofile=$each;
	$tofile=~s/\s/_/g;
	$tofile=~s/\(/_/g;
	$tofile=~s/\)/_/g;
	$tofile=~s/\&/_/g;
	$tofile=~s/\'/_/g;
	$tofile=~s/£¿/__/g;
	$tofile=~s/\?/_/g;
	$tofile=~s/£¬/__/g;
	$tofile=~s/¿/__/g;
	$tofile=~s/=/_/g;
	$tofile=~s/\+/_/g;
	$tofile=~s/\:/_/g;
	$tofile=~s/\*/_/g;
	$tofile=~s/\[/_/g;
	$tofile=~s/\]/_/g;

	$tofile=~s/\250\246//g;  # from mozart
	$tofile=~s/\241\343//g;
	$tofile=~s/\250\250//g;  # from mozart
	$tofile=~s/\250\271//g;  # from mozart
	
	
	print "#".$each, "---  ", $tofile,"\n";
	rename($each, $tofile);
}


