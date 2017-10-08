#!/bin/sh
echo "qianlong" > username
dialog --backtitle "添加管理钱龙系统的管理用户 " --inputbox "请输入用户名" 10 20 "qianlong" 2>username
dialog --backtitle "添加管理钱龙系统的管理用户 " --passwordbox "请输入密码" 10 20 2>passwd
dialog --backtitle "添加管理钱龙系统的管理用户 " --passwordbox "请再输入密码 " 10 20 2>passwd2
username=$(cat username)
passwd=$(cat passwd)
passwd2=$(cat passwd2)
if [ x$passwd == x$passwd2 ];then
	if [ -n $passwd ];then

		[[ ! -n $username ]]&& useradd -d /opt/qianlong $username
	else
		dialog --backtitle " 添加管理钱龙系统的管理用户 " --msgbox "错误, 密码为空" 10 30
		exit 1

	fi
else
	dialog --backtitle " 添加管理钱龙系统的管理用户 " --msgbox "错误, 密码不同" 10 30
	exit 1
fi


if [ x$passwd == x ];then
	dialog --backtitle "添加管理钱龙系统的管理用户 " --msgbox "错误, 密码为空 " 10 30
	rm -f username  passwd  passwd2
	exit 1
else
	echo Passwd $passwd
	echo $passwd |passwd $username --stdin

fi

rm -f username  passwd  passwd2
#echo username  $username
if [  -n $username ];then
#	echo "begin to chown chgrp"
	chown -R $username /opt/qianlong 2>/dev/null
	chgrp -R $username /opt/qianlong 2>/dev/null
else
	exit 1
fi

sed -i '/^PATH/{s/$/\:\/sbin/g}' /opt/qianlong/.bash_profile

if ! grep ulimit /opt/qianlong/.bashrc > /dev/null ;then
echo  ulimit -n 65535 >> /opt/qianlong/.bashrc
echo  ulimit -c 1000 >> /opt/qianlong/.bashrc
fi

exit  0
