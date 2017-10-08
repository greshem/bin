#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

rsync -ave ssh  root@mail.emotibot.com:6787/home/ /home/phabriactor_1.48 /

rsync -ave ssh  root@192.168.1.11:/home/  192.168.1.11

 
rsync -avH --progress '-e ssh -p 6787'   root@mail.emotibot.com:/home/ /mnt/sdb/phabriactor_1.48/ 
rsync -avH --progress '-e ssh -p 6787'   root@mail.emotibot.com:/home/winmail_backup  /mnt/sdb/phabriactor_1.48/winmail_backup 


 
rsync /etc/hosts 192.168.1.104:/etc/hosts

#下面的 rsync 命令将 192.168.0.101 主机上的 /www 目录（不包含 /www/logs 和 /www/conf 子目录）复制到本地的/back up/www/ 。
# rsync -vzrtopg -delete -exclude "logs/" --exclude "conf/" --progress backup@192.168.0.101:/www/ /backup/www/
