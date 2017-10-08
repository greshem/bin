#!/bin/sh
dialog --backtitle "change root passwd"  --passwordbox "please input the passwd " 10 30 2>passwd
dialog --backtitle "change root passwd"  --passwordbox "please input the passwd again            " 10 30 2>passwd2
passwd=$(cat passwd)
passwd2=$(cat passwd2)
if [ $passwd = $passwd2 ];then
echo $passwd |passwd root --stdin
rm -f username  passwd  passwd2
else
dialog --backtitle "change root passwd "  -msgbox "passwd not same ,you should it again" 10 30
exit 1
fi
return 0
