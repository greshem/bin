for each in $(grep lease /var/lib/dhcp/dhcpd.leases |awk '{print $2 }'|sort |uniq );
do
	echo "/bin/diskless_reboot " |sbd -w 1 $each 45 &
	usleep 20
	echo $each success
done
