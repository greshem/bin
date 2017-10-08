if [ $# == 0 ];then
echo "Usage:  input-file.img ";
exit -1 
fi


guestfish -a $1    << EOF
run 
mount /dev/sda1 / 
ls  /etc/sysconfig/network-scripts/
cat /etc/sysconfig/network-scripts/ifcfg-eth0

cat /etc/cloud

EOF
