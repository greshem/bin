#!/usr/bin/perl
#2010_12_20_15:18:38 add by greshem
#��������ģ��
#2010_12_17_11:04:53 add by greshem
#��ǰĿ¼û��tmp ��ʱ�� ���Ὠ��tmp Ŀ¼�� ��Ҫ��
#

foreach (<DATA>)
{
	print $_;
}
__DATA__
#!/usr/bin/perl
use POSIX 'strftime';
use File::Copy;

my $pid=fork();
if($pid)
{
	print "parent process\n";
	exit(0);
}
else
{
	print ("child process\n");
}

setpgrp;

while ( 1==1 )
{
	system("bash do_some_thing.sh ");
	sleep(30);
}

