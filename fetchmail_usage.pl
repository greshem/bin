#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

fetchmail    -k -p pop3  -u zjqian@tnsoft.com.cn  pop.exmail.qq.com     
fetchmail    -k -p imap  -u zjqian@tnsoft.com.cn  pop.exmail.qq.com     

fetchmail    -k -p pop3  -u greshem  gmail.com

fetchmail   -k  --ssl   -p pop3  -u  china.pond   pop.mail.yahoo.com  

fetchmail -a   -k  --ssl   -p pop3  -u  china.pond   pop.mail.yahoo.com    #
fetchmail -a -d 10   -k  --ssl   -p pop3  -u  china.pond   pop.mail.yahoo.com    # 10 秒 运行一次, 
