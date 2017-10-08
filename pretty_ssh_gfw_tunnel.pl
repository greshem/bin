#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#1. ssh 的 sock5 的协议 貌似不稳定
#2. ssh +  squid 的方式.
ssh  teresa  "service squid restart " 

#3. 派茵服务器上搭建 8888 的  squid 代理 服务器 
ssh -CfNg -L 3128:127.0.0.1:3128   root@teresa #  teresa 的squid  映射到本地.

#4. 然后  局域网 发布  3182的地址 http proxy 服务器
socat TCP4-LISTEN:3182,bind=192.168.1.48,reuseaddr,fork, TCP4:localhost:3182

#5. 然后 就可以通过 chrome 的方式连接了. 
