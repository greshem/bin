#!/usr/bin/perl
use File::Copy;

if($^O=~/linux/i)
{
	die("这个命令不支持 linux 下运行 linux 下直接make 就可以了\n");
}
elsif($^O =~/win32/i)
{
	print ("#windows 操作系统\n");	
}


for $each (glob("*.pl"))
{
	print "copy $each c:\\bin \n";
	copy($each, "c:\\bin\\".$each);	
}
	
