#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

./_x_file/_root__2010_03_12.txt:_root__2010_03_12/snort_web/snort/ ��Ѱ���ϵ� snort rules

/usr/sbin/snort -D  -i eth1 -c /etc/snort/snort.conf
/usr/sbin/snort   -i eth1 -c /etc/snort/snort.conf

��������.
������Ҫһ��key �ſ�������.  
http://www.snort.org/snort-rules

#==========================================================================
#����.
1. ��f8 ���沿�� �ҵ�  snort_web �ĳ��� .

2. ��װ snort-mysql 
	yum install snort-mysql

3.  ���ú����ݿ�  /bin/mysql_usage.pl 
#����Ĭ�ϵĿ�����
/usr/bin/mysqladmin -u root password 'q**************n'

4. /tmp/snort_web/snort/etc/snort/  �����еĶ��� ������  /etc/snort/����.
5. snort-mysql -c /etc/snort/snort.conf 
���ֵ�  PCAP_FRAMES �ľ���û��ʲô�����.
6. 

