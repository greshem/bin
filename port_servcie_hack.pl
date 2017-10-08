#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
vsftp httpd tftp dhcp mysql vncviewer ms term telnet ssh samba hydra 端口 cvs https ssl rsh postgrsql nfs smtp pop3
########################################################################
/usr/share/nmap/nmap-service-probes  #常见的服务器 的 fingerprint 
/usr/share/nmap/nmap-os-db

#端口数据库_统计_portscan.txt

	常用的用于端口的 服务器程序的 检测代码
   9989  122437 1273755 nmap-service-probes
3. 常用端口的统计列表
  19925   74102  621710 nmap-services

#==========================================================================


2012_11_12   星期一   add by greshem
21 22 23 25 
53
67 69 
79 finger 
80 
88  krb5 
109 pop3 
119 news 
135  137 138 139 
143 imap 
161 snmp 
177 gdm 
443 https 
513 login  remote login 
635 nfs  mount 
993  imap ssl 
1433  ms sql 
2049 nfs 
3128 squid 
3389  超级终端
4000  QQ   icq 
8080  http 代理 
rsh  rlogin rexec 
ldap    389
gdbserver 
rsync 
socket 代理服务器
bt	#bt p2p 服务器.

########################################################################
#2011_01_06_ add by greshem
1. ftp服务器 vsftpd 
2. ssh 服务器
3. samba
4. svn 服务器 cvs git  #代码服务器, 其他的 cvs 
5. cvs  
6. snort 
7. http https
8. dhcpd 服务器 bootps
9. logtrans 服务器
10. vnc 服务器
11. 乾隆srvplat , l2dcd 
12. rtiosrv 服务器
13. 邮件服务器 qmail sendmail
14. dns 服务器 dns 的cache 服务器 dnsmasq mydns 服务器
15. jabber 服务器
16. nfs 服务器
17. LINUX 打印服务器  cups
18. 传真服务器 hylafax
19. winaoe aoe vblade 服务器
20. BT 服务器
21. iscsi 服务器
22. mysql 服务器  postgresql 
23. nwserv netware 模拟器服务器
24. snmpd 服务器
25. spam 反垃圾邮件
26. syslogd 日志服务器
27.    webmin 服务
28. cpan 安装服务器
29. GENTOO distfile 服务器
30. 外贸服务器， 
31. WINDOWS 和LINUX 文本同步服务器
32. 翻译服务器， google_translate, 翻译网关.
33.  squid 网页代理服务器.
34. 代理服务器 
35. l2dcd srvplat 选股服务器， 行业分析服务器
36. L2DCD 的数据插入服务器，  
37. emule 电驴， 自动下载， 服务器
38. tftp 服务器
39.  pop3 服务器
40. imap 服务器
41.  irc im 服务器
42.  rsync 服务器
43.  socks  代理服务器
44. dict  字典服务器
45.  


echo 服务器.
ntp  服务器
X11 6000 
pcanywhere 
dsniff-2.3.tar.gz/dsniffer.services 的服务列表也是常用的. 
mountd  65301
