
#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__
#server 
#socks5 代理 占用   1122 端口 
ssh -p 7764 -D 1122 -f -N  root@localhost

#--------------------------------------------------------------------------
#client 
curl  -x socks5://127.0.0.1:1122   www.baidu.com
