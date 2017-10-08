#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#2012_01_29   星期日   add by greshem
shutdown -s -f -t 3600 	#一个小时后关机|-f force 强制而没有警告|-s shutdown|-t time 秒. 
shutdown -s -f -t 7200 	#2个小时后关机
shutdown -s -f -t 86400 #一天之后关机
shutdown -r -f -t 20    #20秒之后 重启.  -r reboot
shutdown -l -f -t 20    #20秒之后 重启.  -l loginout 注销.
shutdown -a 			#放弃 重启 关机  -a abort 
########################################################################

