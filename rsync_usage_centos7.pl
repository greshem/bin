#!/usr/bin/perl
my $module=shift or warn("usage: $0 input_dir \n"); 

use File::Basename;

my $name;
if(defined($module))
{
    $name=basename($module);
}

if($module!~/^\//)
{
	warn("input dir should be absoluted \n");
	Usage();
}

open(FILE, ">rsyncd.conf") or die("create rsyncd.conf error \n");
print FILE <<EOF
uid = nobody
gid = nobody
max connections = 200
timeout = 600
use chroot = no
read only = yes
pid file=/var/run/rsyncd.pid
#hosts allow =192.168.3.230 
#hosts allow =127.0.0.1
hosts allow =*
#syslog facility = local7
log file=/var/log/rsyncd.log
#rsync config
#The 'standard' things
[$name]
path = $module
comment =  $name


[qianlong]                   
path = /opt/qianlong/sysdata
comment =  qianlong_data
EOF
;
close(FILE);

print "rsyncd.conf  generated \n";
print "cp rsyncd.conf /etc/rsyncd.conf \n";

sub Usage()
{
print "#======================================================================\n";
print "#Server:  \n";
print "rsync --daemon   \n";

print "#Client: \n";
print " rsync  --list-only  root\@localhost:: \n";
print " rsync  -avz   --bwlimit=\$((2*1024*1024))  rsync://localhost/my_module		#只列出文件列表 \n";
print " rsync  -avz   --bwlimit=\$((2*1024*1024))  rsync://localhost/my_module  my_module    #有了目的目录才开始拷贝. \n";
print "#======================================================================\n";
die("\n");
}
