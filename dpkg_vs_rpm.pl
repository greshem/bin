#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
rpm -qa
dpkg -l

#owning
rpm -qf /bin/ls
dpkg -S /bin/ls

#list
rpm -ql coreutils
dpkg -L coreutils

#force
dpkg --force

#install
dpkg -i input.deb 
rpm -ivh input.rpm 

#remove , erase delete
dpkg -r 
rpm -e 	input.rpm  

