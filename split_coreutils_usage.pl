#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#�ܳ���objdump �Ļ�����, �ָ�� 5�� һ���ļ�, ������������. 
split -l 50000  unix_64.asm   unix_64.asm.

#�ָ�� n��  1000�е��ļ�
split -l 1000   all_wget_no_devel.sh    
split -l 360     pump_2014_04_15.sh  pump_2014_04_15.   #yahoo һ�췢��360���ʼ�.


#����2m �� block,  �ָ�
split -b2m input.mp3  presuffix.

