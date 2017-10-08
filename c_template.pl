#!/usr/bin/perl

#2010_12_21_11:23:14 add by greshem
# 注意不要使用模板， Template , 因为在 livecd 的平台上可能就不支持了. 
#20100601, 添加lmy库的支持。 
#20100713 qzj  测试。 

use POSIX qw(strftime);
$file=$ARGV[0] or die("$0 filename \n");
if($file!~/\.c$/)
{
	$file.=".c";
}
$time=strftime("%Y_%m_%d", localtime(time()));
print $time;
open(FILE,">".$file) or die("open file error $!\n");
while(<DATA>)
{
	if(/__TEMPLATE__/)
	{
		$_=~s/__TEMPLATE__/$file/g;
		print FILE $_;
	}
	elsif(/__TIME__/)
	{
		$_=~s/__TIME__/$time/g;
		print FILE $_;
	}
	else
	{
		print FILE $_;
	}
}
close(FILE);

__DATA__
//########################################################################
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>
#include <dirent.h>
#include <unistd.h>
#include <locale.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <errno.h>
#include <fcntl.h>
#include <time.h>
#include <assert.h>
#include <stringprep.h>
//__TIME__ by greshem. 
int main(int argc, char *argv[])
{
	if(argc != 2)
	{
		printf("Usage: %s file_list \n", argv[0]);
		exit(-1);
	}
	printf("%s\n", "__TEMPLATE__");
	return 1;
}
