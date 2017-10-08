#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

ln -s /tmp3/portage  /usr/portage 


rm -rf /var/cache/eix/portage.eix/
mkdir -p /var/cache/eix/

chmod 777 /var/cache/eix/ -R
eix-update  

eix -n -y linux 

