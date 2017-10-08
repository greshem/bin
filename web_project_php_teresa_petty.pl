#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
petty_china  	#1 
petty_china_new #2
sino_pet 		#3 ini_file/admin
petty_new_site 	#4 ini_file/admin

qianlong kernel compile 
qianlong webadmin 

11698666
zixun
yecha website

