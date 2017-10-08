#!/bin/sh
#LANG=C       cat /root/.ssh/id_rsa.pub | ssh $1 cat '>>' /root/.ssh/authorized_keys
function stage1()
{
LANG=C        ssh_withpasswd -W123456  $1 service dhcpd stop 
retval=$?
return $retval;
}
function stage2()
{
LANG=C        ssh_withpasswd -W111111  $1 service dhcpd stop 
retval=$?
return $retval;
}
function stage3()
{
LANG=C        ssh_withpasswd -Wqazwsx  $1 service dhcpd stop 
retval=$?
return $retval;
}




for each in $( cat /root/open_ssh_port|grep open|awk '{print $2}')
do
echo "deal with $each"
 if ! stage1 $each;then
 # echo stage1 no success
  if ! stage2 $each;then
  #	echo stage2 no success
	if ! stage3 $each;then
  #			echo stage3 no success
	echo "$each need hand by yourself "
	fi
  fi
 fi
done

