#!/usr/bin/perl
#2011_02_21_18:46:02 add by greshem 现在只添加本地的 CO 的命令 之后 再添加通过网络CO 的命令 的建设. 

use File::Basename;
#print basename("/root/linux/bbb"); #结果是. bbb


for (glob("/home/cvsroot//*") )
{
	#print "cvs co file://".$_."\t". basename($_)." \n";
	print "cvs co  \t". basename($_)." \n";
}
