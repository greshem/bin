sub gen_conf()
{
    open(FILE, ">/etc/dnsmasq.conf") or die("open  /etc/dnsmasq.conf error \n");
print FILE <<EOF
authoritative           192.168.1.11
authoritative-port      53              # It's port. Defaults to 53.
authoritative-timeout   10              # Seconds to wait for answers.

recursive              192.168.1.11
recursive-port          53      # It's port. Defaults to 53.
recursive-timeout       90              # Seconds to wait for answers.

listen 0.0.0.0
port 53

chroot /var/empty
user nobody

internal 192.168.168.0/24       # Our internal network
internal 192.168.169.0/24       # Friendly neighbours
internal 192.168.1.0/24
internal 127.0.0.1
EOF
;
    close(FILE);
    print "INFO: /etc/dnsmasf.conf gereranted  \n";
}

gen_conf();

print <<EOF
  http://mirrors.163.com/gentoo/distfiles//dnsproxy-1.16.tar.gz
    ./dnsproxy -d 
EOF
;


