#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#很长的objdump 的汇编代码, 分割成 5万 一个文件, 便于搜索函数. 
split -l 50000  unix_64.asm   unix_64.asm.

#分割成 n个  1000行的文件
split -l 1000   all_wget_no_devel.sh    
split -l 360     pump_2014_04_15.sh  pump_2014_04_15.   #yahoo 一天发送360个邮件.


#按照2m 的 block,  分割
split -b2m input.mp3  presuffix.

