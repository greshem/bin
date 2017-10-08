#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__


http://download.webmin.com/updates/updates.txt
wget http://www.webmin.com/updates.html   
perl urlview.pl  updates.html 

url_extractor_link.py 
