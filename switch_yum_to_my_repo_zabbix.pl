#!/usr/bin/perl
#mdf zabbix in 1.86 
#Server=192.168.1.86
#ServerActive=192.168.1.86

open(FILE, "/tmp/tmp") or die("open file error\n");
for(<FILE>)
{
    chomp;
    my $each=$_;
    $each=~s/\s+$//g;	
    print "#==============\n";
    print " ssh  $each  mkdir /etc/yum.repos.d/old   \n";
    print " ssh  $each  \"mv  /etc/yum.repos.d/*   /etc/yum.repos.d/old \"  \n";
    print " scp /etc/yum.repos.d/*     $each://etc/yum.repos.d/ \n";

    print " ssh $each  pkill package \n";
    print " ssh $each  pkill package \n";
    print " ssh $each  pkill package \n";
    print " sleep 10\n";
    print " ssh $each  yum clean all \n";
    print " ssh $each  yum -y install zabbix-agent  \n";
    print " scp /etc/zabbix/zabbix_agentd.conf   $each:/etc/zabbix/zabbix_agentd.conf \n";
    print " ssh  $each   zabbix_agentd \n";

}
