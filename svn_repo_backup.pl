#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#2012_12_01   ������   add by greshem
1. c:\\home\\svn\\ zip ���ݵ��� 
a. G:\�ٿ�ȫ��\�ʵ�_iso
b. G:\�ٿ�ȫ��\��Ӣ�ٿ�ȫ��_iso

