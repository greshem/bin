echo iptables -t nat -A POSTROUTING -j MASQUERADE
echo 1 >/proc/sys/net/ipv4/ip_forward
