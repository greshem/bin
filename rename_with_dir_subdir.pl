#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

find -type f  	|grep tar.gz$ |awk -F\/  '{print  "mv "   $_ " "  $2"_"$3}'   

find -type d    |awk -F\/  '{print  "mv "   $_ " "  $2"_"$3}'   

#金苗网, 放到 徐浪小兔子里面去.
find -type f  	|grep mp3$ |awk -F\/  '{print  "mv "   $_ " "  $2"_"$3}'   
find -type f    |awk -F\/  '{print  "mv "   $_ " "  $2"_"$3}'   


#It is useful for  kernel version compare , with module compile 
find -type d   | awk -F\/  '{print  "mv "   $_ " "  $2"_"$3"_"$4}' 
find -type d   | awk -F\/  '{print  "mv "   $_ " "  $2"_"$3"_"$4"_"$5}' 
