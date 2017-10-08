#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__


wget -m -np -t 3 -T 3   http://url/  #np -no-parent -mirror 

download_image_form_list.pl
get_cur_frequent_image_size.pl
image_download.pl
lwp_download_image_form_list_v4.pl
wget_to_lwp.pl 

lftp mirror
rsync_usage.pl

reposync #yum  repo mirror


#frequent usage
wget --mirror -t 3 -T 3  -np ftp://vsftpd.beasts.org/users/cevans/untar/


#only tar.gz file 
wget -t 3 -T 3 --mirror -np --accept=tar.gz http://ftp.gnu.org/gnu/

#openstack   centos 7.3
wget -c -r -np --reject=html,gif,A,D,iso -nH    https://mirrors.aliyun.com/centos/7.3.1611/

#openstack   centos 7.3
wget -c -r -np --reject=html,gif,A,D,iso -nH    http://vault.centos.org/7.2.1511/
wget -c -r -np --reject=html,gif,A,D,iso -nH    http://vault.centos.org/7.1.1503/
wget -c -r -np --reject=html,gif,A,D,iso -nH    http://vault.centos.org/7.0.1406/

#33444 port 
wget -c -r -np --reject=html,gif,A,D,iso http://greshem.51vip.biz:33444/linux_src/
