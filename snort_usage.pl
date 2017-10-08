#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

./_x_file/_root__2010_03_12.txt:_root__2010_03_12/snort_web/snort/ 下寻找老的 snort rules

/usr/sbin/snort -D  -i eth1 -c /etc/snort/snort.conf
/usr/sbin/snort   -i eth1 -c /etc/snort/snort.conf

规则下载.
不过需要一个key 才可以下载.  
http://www.snort.org/snort-rules

#==========================================================================
#部署.
1. 在f8 上面部署 找到  snort_web 的程序 .

2. 安装 snort-mysql 
	yum install snort-mysql

3.  设置好数据库  /bin/mysql_usage.pl 
#设置默认的空密码
/usr/bin/mysqladmin -u root password 'q**************n'

4. /tmp/snort_web/snort/etc/snort/  的所有的东西 拷贝到  /etc/snort/下面.
5. snort-mysql -c /etc/snort/snort.conf 
出现的  PCAP_FRAMES 的警告没有什么问题的.
6. 

