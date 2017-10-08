for each in $(cat /var/lib/dhcp/dhcpd.leases |grep ^lease |sort |uniq |awk '{print $2}')
do
echo reboot $each 
echo  reboot -f |sbd -w 1 $each 45
done

