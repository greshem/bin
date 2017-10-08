#!/usr/bin/perl
my $path=shift or die("Usage: $0 iput_dir \n");
$buf=`grep $path /etc/exports `;
if($buf=~/$path/)
{
    die(" $path  have already  in int, skip  \n");
}

if($path!~/^\//)
{
    die("not   abs path error\n");
}

open(FILE, ">> /etc/exports") or die(" file open error \n");
print FILE <<EOF
$path *(sync,rw,no_root_squash)
EOF
;

#service rpcbind start
#service nfs start


system(" service rpcbind start ");
system(" service nfs  start ");
