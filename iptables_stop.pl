#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
setenforce 0 			
systemctl stop firewalld.service 		#停止firewall
systemctl disable firewalld.service 		#禁止firewall开机启动
firewall-cmd --state 				#查看默认防火墙状态（关闭后显示notrunning，
