#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

wget http://dl.fedoraproject.org/pub/epel/ -O /tmp/epel.html
#urlveiw.pl   /tmp/epel.html  |egrep "^[4|5|6]" > /tmp/epel_version


cat /tmp/epel.html  |awk -Fhref= '{print $2}'  |awk -F\> '{print $1}'  |sed 's/\"//g'  |egrep "^[4|5|6]" > /tmp/epel_version 

for each in $(cat /tmp/epel_version)
do
dest=$(echo $each  |sed 's/\//_/g' )
echo   wget http://download.fedoraproject.org/pub/epel/$each/i386/  -O /tmp/epel_${dest}_index.html
wget http://download.fedoraproject.org/pub/epel/$each/i386/  -O /tmp/epel_${dest}_index.html
done

#linkextractor.pl  /tmp/epel.html


wget http://download.fedoraproject.org/pub/epel/4/i386/epel-release-4-10.noarch.rpm
wget http://download.fedoraproject.org/pub/epel/5/i386/epel-release-5-4.noarch.rpm
wget http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
