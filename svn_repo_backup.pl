#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#2012_12_01   星期六   add by greshem
1. c:\\home\\svn\\ zip 备份到了 
a. G:\百科全书\词典_iso
b. G:\百科全书\大英百科全书_iso

