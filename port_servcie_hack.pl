#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
vsftp httpd tftp dhcp mysql vncviewer ms term telnet ssh samba hydra �˿� cvs https ssl rsh postgrsql nfs smtp pop3
########################################################################
/usr/share/nmap/nmap-service-probes  #�����ķ����� �� fingerprint 
/usr/share/nmap/nmap-os-db

#�˿����ݿ�_ͳ��_portscan.txt

	���õ����ڶ˿ڵ� ����������� ������
   9989  122437 1273755 nmap-service-probes
3. ���ö˿ڵ�ͳ���б�
  19925   74102  621710 nmap-services

#==========================================================================


2012_11_12   ����һ   add by greshem
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
3389  �����ն�
4000  QQ   icq 
8080  http ���� 
rsh  rlogin rexec 
ldap    389
gdbserver 
rsync 
socket ���������
bt	#bt p2p ������.

########################################################################
#2011_01_06_ add by greshem
1. ftp������ vsftpd 
2. ssh ������
3. samba
4. svn ������ cvs git  #���������, ������ cvs 
5. cvs  
6. snort 
7. http https
8. dhcpd ������ bootps
9. logtrans ������
10. vnc ������
11. Ǭ¡srvplat , l2dcd 
12. rtiosrv ������
13. �ʼ������� qmail sendmail
14. dns ������ dns ��cache ������ dnsmasq mydns ������
15. jabber ������
16. nfs ������
17. LINUX ��ӡ������  cups
18. ��������� hylafax
19. winaoe aoe vblade ������
20. BT ������
21. iscsi ������
22. mysql ������  postgresql 
23. nwserv netware ģ����������
24. snmpd ������
25. spam �������ʼ�
26. syslogd ��־������
27.    webmin ����
28. cpan ��װ������
29. GENTOO distfile ������
30. ��ó�������� 
31. WINDOWS ��LINUX �ı�ͬ��������
32. ����������� google_translate, ��������.
33.  squid ��ҳ���������.
34. ��������� 
35. l2dcd srvplat ѡ�ɷ������� ��ҵ����������
36. L2DCD �����ݲ����������  
37. emule ��¿�� �Զ����أ� ������
38. tftp ������
39.  pop3 ������
40. imap ������
41.  irc im ������
42.  rsync ������
43.  socks  ���������
44. dict  �ֵ������
45.  


echo ������.
ntp  ������
X11 6000 
pcanywhere 
dsniff-2.3.tar.gz/dsniffer.services �ķ����б�Ҳ�ǳ��õ�. 
mountd  65301
