#!/usr/bin/perl
#20100113
#断言传入的目录列表下面没有子目录了。 所以 传入的文件是 目录列表。 
$file=shift or die("Usage: $0 all_dir \n");
open(FILE, $file) or die("open file error\n");
for $line (<FILE>)
{
	chomp $line ;
	if( ! -d $line)
	{
		warn("断言错误:  $line  not dir\n");
	}
	else
	{
		opendir(DIR, $line) or warn("open dir $line error\n");
		@dirs= grep { -d $line."/".$_ && !/^\./} readdir(DIR);
		if(scalar(@dirs)>0)
		{
			for(@dirs)
			{
				print "rm -rf ", $line."/".$_,"\n";
			}
		}
		close(DIR);
	}
}
