#!/usr/bin/perl
sub print_cmd_line()
{
	print <<EOF
	 hostapd -dd /etc/hostapd.conf

#1. 把 无线网卡 配置好ip 
	ifconfig  wlan3  172.16.10.33
#2. dhcp 地址分配.  
dnsmasq --log-queries   --strict-order --log-queries --bind-interfaces --interface=wlan3     --port=0 --except-interface=lo   --dhcp-range=172.16.10.100,172.16.10.200,255.255.255.0,12000s  

#3. ipfoward 解决一下. 
#	ip_forward.sh 
iptables -t nat -A POSTROUTING -j MASQUERADE
echo 1 >/proc/sys/net/ipv4/ip_forward

EOF
;

}
sub gen_conf()
}
	open(FILE, "hostapd.conf") 
	print FILE <<EOF	
   interface=wlan3
    driver=nl80211
    ssid=pcduino
    hw_mode=g
    channel=11
    dtim_period=1
    rts_threshold=2347
    fragm_threshold=2346
    macaddr_acl=0
    auth_algs=1
    ieee80211n=0
    wpa=2
    wpa_passphrase=1234567890
    wpa_key_mgmt=WPA-PSK
    wpa_pairwise=TKIP
    rsn_pairwise=CCMP
EOF
;
	close(FILE);
}
