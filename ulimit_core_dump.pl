#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#!/bin/sh

if ! grep unlimit /etc/bashrc;then
echo  ulimit -n 65535 >> /etc/bashrc
echo  ulimit -c unlimited >> /etc/bashrc
fi
########################################################################
#ulimit -a 
# core file size          (blocks, -c) unlimited
# data seg size           (kbytes, -d) unlimited
# scheduling priority             (-e) 0
# file size               (blocks, -f) unlimited
# pending signals                 (-i) 15944
# max locked memory       (kbytes, -l) 64
# max memory size         (kbytes, -m) unlimited
# open files                      (-n) 65535
# pipe size            (512 bytes, -p) 8
# POSIX message queues     (bytes, -q) 819200
# real-time priority              (-r) 0
# stack size              (kbytes, -s) 10240
# cpu time               (seconds, -t) unlimited
# max user processes              (-u) 1024
# virtual memory          (kbytes, -v) unlimited
# file locks                      (-x) unlimited

