#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#2012_01_29   ������   add by greshem
shutdown -s -f -t 3600 	#һ��Сʱ��ػ�|-f force ǿ�ƶ�û�о���|-s shutdown|-t time ��. 
shutdown -s -f -t 7200 	#2��Сʱ��ػ�
shutdown -s -f -t 86400 #һ��֮��ػ�
shutdown -r -f -t 20    #20��֮�� ����.  -r reboot
shutdown -l -f -t 20    #20��֮�� ����.  -l loginout ע��.
shutdown -a 			#���� ���� �ػ�  -a abort 
########################################################################

