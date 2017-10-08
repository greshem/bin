#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

#参考下面文档:
    socks5_proxy.pl 

cd  /tmp3/portage/net-proxy/polipo/polipo-1.1.1
make 

cat > /etc/polipo.conf <<EOF
proxyAddress = "0.0.0.0"  #监听哪个网卡的IP
allowedClients = 192.168.1.0/24  #允许哪些客户端连进来
socksParentProxy = "127.0.0.1:1122"  #SSH跑起来的SOCKS5代理
socksProxyType = socks5 #代理类型
port= 8123
EOF
;

nohup polipo -c  /etc/polipo.conf  & 
