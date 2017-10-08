#!/bin/sh
rm -f passwd
rm -f passwd2
dialog --backtitle "修改用户密码"  --passwordbox "请输入密码,密码不回显" 10 30 2>passwd
dialog --backtitle "修改用户密码"  --passwordbox "确认密码             " 10 30 2>passwd2
passwd=$(cat passwd)
passwd2=$(cat passwd2)
if [ $passwd = $passwd2 ];then
echo $passwd |passwd root --stdin
rm -f username  passwd  passwd2
else
dialog --backtitle "修改用户密码"  -msgbox "passwd not same ,you should it again" 10 30
exit 1
fi

