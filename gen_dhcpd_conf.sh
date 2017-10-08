usage()
{
	echo "Usage: $0 [ --dhcpd-conf <orgin_dhcpd> ] [--fixip-mac-list <file>] [ --deny-mac-list <file>]  [ --start-ip <ip>]"
	exit 1
}
function get_mac()
{
grep 00:c0 /var/lib/dhcp/dhcpd.leases|sort |uniq |awk '{print $3}' |sed 's/;$//g' > hudie_mac_2
if [ $(grep -c ^ hudie_mac_2) -gt $(grep -c ^ hudie_mac) ];then
 echo will renew the mac spool
 yes |cp hudie_mac_2 hudie_mac
fi
}

function echo_node_for_dhcpd
{
node_id=$(echo $2 |cut -d\. -f4)
##echo node${node_id}
echo host node${node_id} \{
echo    hardware ethernet $1\;
echo    fixed-address $2\;
echo \}
}
function echo_deny_node_for_dhcpd
{
node_id=$(echo $2|cut -d\. -f4)
echo "host node3${node_id} {"
echo "    hardware ethernet $1;"
echo "    deny bootp;"
echo "    deny booting;"
echo "}"
}
function ip2hex()
{
local a b c d 
a=$(echo $1|cut -d\. -f1)
b=$(echo $1|cut -d\. -f2)
c=$(echo $1|cut -d\. -f3)
d=$(echo $1|cut -d\. -f4)
a=$(printf %X $a)
 [ $(expr length $a) -eq 1 ]&&a=0$a
b=$(printf %X $b)
 [ $(expr length $b) -eq 1 ]&&b=0$b
c=$(printf %X $c)
 [ $(expr length $c) -eq 1 ]&&c=0$c
d=$(printf %X $d)
 [ $(expr length $d) -eq 1 ]&&d=0$d
echo $a$b$c$d
}
function hex2ip()
{
#	echo "$1"
    let n=0x$1;
#	echo $n

    let o1='(n>>24)&0xff';
    let o2='(n>>16)&0xff';
    let o3='(n>>8)&0xff';
    let o4='n & 0xff';
    echo $o1.$o2.$o3.$o4;
}
function number2ip()
{
    let n="$1";

    let o1='(n>>24)&0xff';
    let o2='(n>>16)&0xff';
    let o3='(n>>8)&0xff';
    let o4='n & 0xff';
    echo $o1.$o2.$o3.$o4;
}

function ip2number()
{
local a b c d 
d=$(echo $1|cut -d\. -f1)
c=$(echo $1|cut -d\. -f2)
b=$(echo $1|cut -d\. -f3)
a=$(echo $1|cut -d\. -f4)
sum=0
sum=$((d*256*256*256+c*256*256+b*256 +a))
echo $sum
}
echo_dhcpd_conf()
{
 echo  option space PXE\;
echo  option PXE.mtftp-ip               code 1 = ip-address;
echo  option PXE.mtftp-cport            code 2 = unsigned integer 16\;
echo  option PXE.mtftp-sport            code 3 = unsigned integer 16\;
echo  option PXE.mtftp-tmout            code 4 = unsigned integer 8\;
echo  option PXE.mtftp-delay            code 5 = unsigned integer 8\;
echo  option PXE.discovery-control      code 6 = unsigned integer 8\;
echo  option PXE.discovery-mcast-addr   code 7 = ip-address\;
echo
echo  allow unknown-clients\;
echo  allow bootp\;
echo  allow booting\;
echo  \#ping-check true\;
echo  \#ping-timeout 2\;
echo  option subnet-mask 255.255.255.0\;
echo  option broadcast-address 192.168.3.255\;
echo  option domain-name \"qianlong\"\;
echo  option routers 192.168.3.254\;
echo  option vendor-class-identifier \"PXEClient\"\;
echo  vendor-option-space PXE;
echo  option PXE.mtftp-ip 0.0.0.0\;
echo
echo  ddns-update-style none\;
echo
echo  subnet 192.168.3.0 netmask 255.255.255.0 {
echo            range dynamic-bootp 192.168.3.220 192.168.3.223\;
echo  default-lease-time 1600\;
echo  max-lease-time 3200\;
echo  next-server 192.168.3.200\;
echo  filename \"pxelinux.0\"\;
echo
echo  }

}
echo_pxe_cfg()
{
echo default  2
echo prompt 2
echo timeout 6
echo label 2 nfs
echo   kernel temp_kernel
echo   append root=/dev/nfs nfsroot=192.168.3.200:/opt/qianlong/i386/client                  ip=dhcp vga=0x301  init=/init
}
############################################################
#
#
############################################################

while [ $# -gt 0 ];do
 case $1 in
	--dhcpd-conf)
	  DHCPD_CONF=$2
	shift;shift
	;;
	--fixip-mac-list)
	  FIXIP_MAC_LIST=$2
	shift;shift
	;;
	--deny-mac-list)
	  DENY_MAC_LIST=$2
	shift;shift
	;;
	--start-ip)
	  START_IP=$2
	shift;shift
	;;
	*)
	echo $1
	shift
	;;
 esac
done
#if [ -z "$DHCPD_CONF" ];then
#	usage
#fi
if [ -z "$FIXIP_MAC_LIST" ];then
echo	usage
fi
if [ -z "$DENY_MAC_LIST" ];then
echo 	usage
fi
if [ -z "$START_IP" ];then
	usage
fi

get_mac
##########################################
#gen_common_dhcpd_conf
##########################################
echo_dhcpd_conf
##########################################
fix_mac=$(cat $FIXIP_MAC_LIST)
deny_mac=$(cat $DENY_MAC_LIST)
ip_temp=$(ip2number $START_IP);
##########################################
#gen_fix_ip dhcpd node
#########################################
for each in $fix_mac
do
#ip_field4=$ip_temp
ip_temp=$((ip_temp+1))
ip=$(number2ip $ip_temp)
echo_node_for_dhcpd  $each  $ip
#echo =======================
#echo_deny_node_for_dhcpd $each $ip
#echo +++++++++++++++++++++++++++
echo_pxe_cfg > \1
 touch /tftpboot/pxelinux.cfg/$(ip2hex $ip)
yes |cp \1  /tftpboot/pxelinux.cfg/$(ip2hex $ip)
done
##########################################
#gen_deny dhcpd node
#########################################
for each in $deny_mac
do
ip_temp=$((ip_temp+1))
ip=$(number2ip $ip_temp)
echo_deny_node_for_dhcpd $each $ip
done

