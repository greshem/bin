#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#testing in centos7 
#1. 
cat >> /lib/systemd/system/rc-local.service <<EOF
[Install]
WantedBy=multi-user.target
EOF

#2. 
chmod +x /etc/rc.d/rc.local

#3. 开启 rc-local.service 服务：
systemctl   enable   rc-local.service
systemctl   start  rc-local.service


#4. append my scripts to  /etc/rc.d/rc.local

