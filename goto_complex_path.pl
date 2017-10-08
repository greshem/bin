#!/usr/bin/perl
print_common_path();
print_win_config_reg();

#==========================================================================
sub print_win_config_reg()
{
	print "#==========================================================================\n";
	print "#windows register path  \n";
	for (grep {-d } (glob("/mnt/*")))
	{
		$reg_path= $_."/WINDOWS/system32/config/";
		#print $reg_path."\n";
		if (-d  $reg_path)
		{
			print  "cd ".$reg_path."                                  #cf.pl hive \n";
		}	
	}

}
#print_url();
sub print_url()
{
print  <<EOF
#主页.
http://www.petty-china.com/petty_china/index.php
http://www.petty-china.com/petty_china_new/index.php
http://www.sino-pet.com/sino_pet/index.php

#后台.
#http://www.petty-china.com/petty_china/inifile_web/  #, 这个没有.
http://www.petty-china.com/petty_china_new/inifile_web/
http://www.sino-pet.com/sino_pet/inifile_web/

http://192.168.0.10/
http://192.168.0.10/petty_china/
http://192.168.0.10/petty_china_new/
http://192.168.0.10/sino_pet/
http://192.168.0.10/petty_new_site/
http://192.168.0.10/petty_new_site/inifile_web_v2/

http://172.16.10.243/
http://172.16.10.243/petty_china/
http://172.16.10.243/petty_china_new/
http://172.16.10.243/sino_pet/
http://172.16.10.243/petty_new_site/
http://172.16.10.243/petty_new_site/inifile_web_v2/

EOF
;
}

sub print_common_path()
{

use POSIX 'strftime';
$month=POSIX::strftime('%Y%m',localtime(time()));
print <<EOF
cd /var/spool/mqueue && ls -la -h
cd /var/spool/mail/ && ls -la -h
cd /var/spool/clientmqueue/ && ls -la -h


cd /lib/modules/2.6.33.3-85.fc13.x86_64/build
cd /usr/share/doc/systemtap-1.2/examples/
cd /vld/sys/ml45/program/lond


cd /var/log/httpd
cd /var/lib/libvirt/images/
cd /usr/share/rtiosrv/
cd /sys/class/net/
cd /media/sdb1/_pre_cache/
cd /media/sdb1/_x_file/xfile_$month/
EOF

}
sub print_yum()
{
print <<EOF
cd /var/cache/yum/x86_64/13/fedora-debuginfo/packages
cd /var/cache/yum/fedora-debuginfo/packages
EOF

}
