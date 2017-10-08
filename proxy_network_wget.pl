#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
wget -e "http_proxy=http://gsx:3128/" http://www.google.com

http_proxy="http://172.16.3.52:3128"
export http_proxy


#goagent
wget -e "http_proxy=http://192.168.1.12:8087/" goagent.org 
wget -e "http_proxy=http://127.0.0.1:8087/" goagent.org 

