#!/bin/sh
dialog --backtitle "�޸�root�û�����"  --passwordbox "����������,���벻����" 10 30 2>passwd

dialog --backtitle "�޸�root�û�����"  --passwordbox "ȷ������             " 10 30 2>passwd2
passwd=$(cat passwd)
passwd2=$(cat passwd2)
if [ $passwd == $passwd2 ];then
	if [ x$passwd != x ];then
	echo $passwd |passwd root --stdin
	else
		dialog --backtitle "�޸�root�û�����"  --msgbox "����Ϊ��,��Ҫ��������" 10 30
		exit 1
	fi
rm -f username  passwd  passwd2
else
dialog --backtitle "�޸�root�û�����"  --msgbox "���벻��ͬ,��Ҫ��������" 10 30
exit 1
fi
exit 0
