#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#server 
#ע��: Ҫ����һ��ʱ�� ����Ч  һ���� ���Сʱ. 

cat >  /etc/ntp.conf  <<EOF
restrict 127.0.0.1 
restrict default  nomodify 
server  127.127.1.0     # local clock ����lock ʱ��  
fudge   127.127.1.0 stratum 10

<<EOF


#==========================================================================
client  
ntpdate server 1.pool.ntp.org

#windows  ��ntpdate ������.
ntpdate time.windows.com
ntpdate	time.nist.gov
ntpdate	time-nw.nist.gov
ntpdate	time-a.nist.gov
ntpdate	time-b.nist.gov
ntpdate	172.16.1.251
