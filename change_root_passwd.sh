#!/bin/sh
dialog --backtitle "修改root用户密码"  --passwordbox "请输入密码,密码不回显" 10 30 2>passwd

dialog --backtitle "修改root用户密码"  --passwordbox "确认密码             " 10 30 2>passwd2
passwd=$(cat passwd)
passwd2=$(cat passwd2)
if [ $passwd == $passwd2 ];then
	if [ x$passwd != x ];then
	echo $passwd |passwd root --stdin
	else
		dialog --backtitle "修改root用户密码"  --msgbox "密码为空,需要重新输入" 10 30
		exit 1
	fi
rm -f username  passwd  passwd2
else
dialog --backtitle "修改root用户密码"  --msgbox "密码不相同,需要重新输入" 10 30
exit 1
fi
exit 0
