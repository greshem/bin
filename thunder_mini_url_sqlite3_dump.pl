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
#1. win7 ��Ѹ�׵����ݿ��� , ͨ��  �鿴 mini Ѹ��ռ�õ��ļ�����Ϳ��Զ�λ���� 
#doit  
ie.pl "C:\\Users\\Public\\Documents\\Thunder Network\\MiniXLOEM\\thunder\\Data\\TaskDb.dat"

2. 
#sqlite3 �����ݿ����� 
#G:\\sdb1\\_xfile\\2012_all_iso\\_xfile_201210\\_d_frequent_1\\sqlite-autoconf-3071401.tar
#����ļ� ����һ��
fedora16 ò�Ʋ���.

#3. 
sqlite3 /tmp/TaskDb.dat <<EOF
.output /tmp/thunder_mini_url_$today.txt
select url from taskbase;
EOF

#���е�Ѹ�׵����ص����� ����������. 

#�����еķ�ʽ�۲� Ѹ�׵����ݱ��, �ȽϷѾ� ��  sqliteman �ķ�ʽȥ����
#	�鿴 ÿ�� ���  schema  , �Ƚ�ʡ��. 
EEOOFF
;

print "\n";


print "#/tmp/thunder_mini_url_$today.txt ,created \n";

