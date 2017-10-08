#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
use POSIX qw(strftime);
$today=POSIX::strftime('%Y-%m-%d',localtime(time()));
print "Today -> " .$today."\n";

print <<EEOOFF
#1. win7 下迅雷的数据库是 , 通过  查看 mini 迅雷占用的文件句柄就可以定位到了 
#doit  
ie.pl "C:\\Users\\Public\\Documents\\Thunder Network\\MiniXLOEM\\thunder\\Data\\TaskDb.dat"

2. 
#sqlite3 的数据可以用 
#G:\\sdb1\\_xfile\\2012_all_iso\\_xfile_201210\\_d_frequent_1\\sqlite-autoconf-3071401.tar
#这个文件 编译一下
fedora16 貌似不行.

#3. 
sqlite3 /tmp/TaskDb.dat <<EOF
.output /tmp/thunder_mini_url_$today.txt
select url from taskbase;
EOF

#所有的迅雷的下载的链接 都导出来了. 

#命令行的方式观察 迅雷的数据表库, 比较费尽 用  sqliteman 的方式去管理
#	查看 每个 表的  schema  , 比较省力. 
EEOOFF
;

print "\n";


print "#/tmp/thunder_mini_url_$today.txt ,created \n";

