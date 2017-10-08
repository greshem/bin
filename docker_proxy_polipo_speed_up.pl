#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

#2017_02_03   星期五   add by greshem
1. 公司的速度快 docker 家里的docker 速度慢
	docker pull 的时候 通过公司 进行下载

2.  公司机器 ssh  隧道到     petty5
		的   7764 端口

########################################################################
3.   7764 端口做一个  socks5的代理
#server 
#socks5 代理 占用   1122 端口 
ssh -p 7764 -D 1122 -f -N  root@localhost

#--------------------------------------------------------------------------
#client  测试一下 
curl  -x socks5://127.0.0.1:1122   www.baidu.com

########################################################################
4. docker 支持 http 代理 不支持 socks5代理 转换一下,  
	polipo_socks5_2_http_proxy.pl

cd  /tmp3/portage/net-proxy/polipo/polipo-1.1.1
make 

cat > /etc/polipo.conf <<EOF
proxyAddress = "0.0.0.0"  #监听哪个网卡的IP
allowedClients = 192.168.1.0/24  #允许哪些客户端连进来
socksParentProxy = "127.0.0.1:1122"  #SSH跑起来的SOCKS5代理
socksProxyType = socks5 #代理类型
port = 8123
EOF
;

nohup polipo -c  /etc/polipo.conf  & 

########################################################################
5  docker 添加 服务重启一下.
cat >>  /etc/sysconfig/docker  <<EOF

HTTP_PROXY=http://192.168.1.5:8123
http_proxy=http://192.168.1.5:8123
EOF
systemctl restart docker 

wget -e "http_proxy=http://192.168.1.5:8123/" http://www.baidu.com
curl -x 192.168.1.5:8123 www.baidu.com


