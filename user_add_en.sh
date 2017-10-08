#!/bin/sh
dialog --backtitle "add user to manager qianlong system " --inputbox "Please input username" 10 20 "qianlong" 2>username
dialog --backtitle "add user to manager qianlong system " --passwordbox "Please input password" 10 20 2>passwd
dialog --backtitle "add user to manager qianlong system " --passwordbox "Please input password again " 10 20 2>passwd2
username=$(cat username)
passwd=$(cat passwd)
passwd2=$(cat passwd2)
if [ $passwd = $passwd2 ];then
	[ ! -n $username ]&& useradd -d /opt/qianlong $username
else
	dialog --backtitle "add user to manager qianlong system " --msgbox "passwd not same ,you should it again" 10 30
	exit 1
fi


if [  -n $passwd ];then
	echo $passwd |passwd $username --stdin
else

	dialog --backtitle "add user to manager qianlong system " --msgbox "passwd not supply  ,you should give you passwd " 10 30
	rm -f username  passwd  passwd2
	exit 1
fi

rm -f username  passwd  passwd2
#echo username  $username
if [  -n $username ];then
#	echo "begin to chown chgrp"
	chown -R $username /opt/qianlong 2>/dev/null
	chgrp -R $username /opt/qianlong 2>/dev/null
fi

sed -i '/^PATH/{s/$/\:\/sbin/g}' /opt/qianlong/.bash_profile

if ! grep ulimit /opt/qianlong/.bashrc > /dev/null ;then
echo  ulimit -n 65535 >> /opt/qianlong/.bashrc
echo  ulimit -c 1000 >> /opt/qianlong/.bashrc
fi
return 0
