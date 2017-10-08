#!/usr/bin/perl
our $wifi_name=shift;

if(!defined($wifi_name))
{
	$wifi_name="wlan0";
}
	

print <<EOF

#SSID: ZJ-PRODUCT
#SSID: ZJ-ENGINEER
#SSID: ZJ-ENGINEER-2

ip link set  $wifi_name up  #up 
iw dev  $wifi_name   scan  |grep SSID 



yum install   wpa_supplicat

#gen conf with  encrypt  password 
wpa_passphrase $wifi_name 

#mdf  /etc/wpa_supplicant/wpa_supplicant.conf
#append  as follow 
network={
	ssid="ssid_name"
    psk="ssid_password"
}

#Ö´ÐÐÃüÁî
#exec cmd as follow 
wpa_supplicant -B -i $wifi_name -c /etc/wpa_supplicant/wpa_supplicant.conf
dhclient  $wifi_name 

iw  $wifi_name link 
ip  addr show  $wifi_name 
EOF
;
