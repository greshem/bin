#2013_05_30   星期四   add by greshem

gen_3proxy_cfg();

print "3proxy  3proxy.cfg  #run it \n";


sub gen_3proxy_cfg()
{
	open(FILE, "> 3proxy.cfg") or die("create  3proxy.cfg ok \n");
	print FILE <<EOF
# logging goes to stdout
log

# empty active access list
# Access list must be flushed every time you creating new access list for new service
#新的ACL（访问控制列表）开始。
flush

# Nameserver to use for name resolutions
#DNS服务器地址。这里用了Google的2个免费DNS，也可设置为ISP提供的。
nserver 8.8.8.8
nserver 4.4.4.4

# Cache <cachesize> records for name resolution
#DNS缓存。
nscache 65536

# sets ip address of internal interface
#绑定“内网”接口的IP地址，本文中即无线互连接口。
internal 10.4.144.220

# sets ip address of external interface
#绑定“外网”接口的IP地址。
external 192.168.199.102

# authentication by access control list with username ignored
#选择认证机制为iponly（仅根据IP控制）。
auth iponly

# Access control entries
# allow <userlist> <sourcelist> <targetlist> <targetportlist> <operationlist> <weekdayslist> <timeperiodslist>
#允许所有连接。
allow *

# sets maximum number of simulationeous connections to each services started after this command
#限制最大同时连接数为100。
maxconn 100

# SOCKS 4/4.5/5 proxy (default port 1080)
proxy -a -p1984 

# anonymous proxy (no information about client reported)
#开启SOCKS代理。
socks -a

#dns proxy 
dnspr -a 

# sets bandwith limitation filter to <rate> bps (bits per second)
#限制最大带宽。
bandlimin 819200 *

#配置结束。
# End of configuration
end
EOF
;
	close(FILE);
	print ("#generate 3proxy.cfg OK \n");
}
