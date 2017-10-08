#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#server 
#注意: 要过了一段时间 才有效  一般是 半个小时. 

cat >  /etc/ntp.conf  <<EOF
restrict 127.0.0.1 
restrict default  nomodify 
server  127.127.1.0     # local clock 本地lock 时钟  
fudge   127.127.1.0 stratum 10

<<EOF


#==========================================================================
client  
ntpdate server 1.pool.ntp.org

#windows  下ntpdate 服务器.
ntpdate time.windows.com
ntpdate	time.nist.gov
ntpdate	time-nw.nist.gov
ntpdate	time-a.nist.gov
ntpdate	time-b.nist.gov
ntpdate	172.16.1.251
