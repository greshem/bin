#!/usr/bin/perl
use File::Copy;

if($^O=~/linux/i)
{
	die("������֧�� linux ������ linux ��ֱ��make �Ϳ�����\n");
}
elsif($^O =~/win32/i)
{
	print ("#windows ����ϵͳ\n");	
}


for $each (glob("*.pl"))
{
	print "copy $each c:\\bin \n";
	copy($each, "c:\\bin\\".$each);	
}
	
