gen_dnsmasq_conf();
gen_resolv();
gen_hosts();
print "cmd:  dnsmasq  \n";

sub gen_dnsmasq_conf()
{
    open(FILE, ">>/etc/dnsmasq.conf") or die("open dnsmasq error \n");
    print FILE <<EOF
    resolv-file=/etc/resolv.conf.dnsmasq
    addn-hosts=/etc/dnsmasq.hosts
    #addn-hosts=/etc/dnsmasq.d/dnsmasq_r2.hosts
    #conf-dir=/etc/dnsmasq.d
    address=/www.youtube.com/4.4.4.4
EOF
;
    close(FILE);
    print ("OK  /etc/dnsmasq.conf \n");
}
sub gen_resolv()
{
    open(RESOLV, ">/etc/resolv.conf.dnsmasq") or die("create  /etc/resolv.conf.dnsmasq error \n");
    print RESOLV <<EOF
nameserver 8.8.8.8                                                                             
nameserver 8.8.4.4                                                                             
nameserver 114.114.114.114        
EOF
;
    close(RESOLV);
    print ("OK /etc/resolv.conf.dnsmasq \n");
}



sub gen_hosts()
{
    open(HOSTS, ">/etc/dnsmasq.hosts") or die("create /etc/dnsmasq.hosts error \n");
    print HOSTS <<EOF
139.196.170.125 qa
162.211.181.182 teresa
162.211.181.182 sara
180.168.66.46 mail.emotibot.com.cn 
EOF
;
    close(HOSTS);
    print("OK /etc/dnsmasq.hosts \n");
}
