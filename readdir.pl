#!/usr/bin/perl
#add log
use Cwd;
my_readdir(getcwd());

sub my_readdir($dir)
{
	(my $dir)=@_;
	chdir($dir);
	opendir(DIR,$dir);
	my @dirs=readdir(DIR);
	for $each (@dirs)
	{
		if (-f $dir."/".$each) 
		{
		print $each,"\n";
		}
		elsif( -d $dir."/".$each && $each!~/^\./)
		{
			my_readdir($dir."/".$each);
		}
		else
		{
	#		print $each,"\n";
		}
		
	}
	chdir($dir."/..");
}

