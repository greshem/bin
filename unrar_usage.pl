#!/usr/bin/perl
use Cwd;
$pwd=getcwd();

for( grep { -f } glob($pwd."/*.rar"))
{
	my $dest_dir=$_;
	$dest_dir=~s/\.rar//g;
	my $each=$_;
	if($^O=~/win/i)
	{
		$dest_dir=~s/\//\\/g;
		$each=~s/\//\\/g;
	}
	print "mkdir $dest_dir\n";
	print "unrar x -o+ -r  $each $dest_dir\n"; 
		
}

sub shell_usage()
{
	foreach (<DATA>)
	{
		print $_;
	}
}
__DATA__
#!/bin/bash
for each in $(dir -1 |grep rar$)
do
#x extrace
#-o+   覆盖模式. 
#r 	 递归模式.
#  $each 是 解压文件. 
#  最后一个是 输出的目录， 假如没有这个目录， 会重新创建这个目录.  
echo unrar x -o+ -r $each ${each%%.rar}
unrar x -o+ -r $each ${each%%.rar}
	if [ $? -eq 1 ];then
		mkdir ${each%%.rar}
		unrar x -o+ -r $each ${each%%.rar}

	fi
done

