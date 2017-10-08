#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#1.
phantomjs_usage.pl 
 /tmp3/linux_src/phantomjs-2.1.1-linux-x86_64//bin/phantomjs  /tmp3/linux_src/phantomjs-2.1.1-linux-x86_64/examples/rasterize.js  http://www.ip138.com/  output.png


#2
curl -s checkip.dyndns.com | cut -d' ' -f 6  | cut -d'<' -f 1 

#3
wget http://www.prettyindustries.com/ip.php
curl http://www.prettyindustries.com/ip.php

#shuguang  101.85.76.32

curl http://www.prettyindustries.com/name_ip_data.txt 


#155322s70k.51mypc.cn
greshem.51vip.biz
