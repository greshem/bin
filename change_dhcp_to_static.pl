#!/usr/bin/perl
#centos7 dhcpd change to static 


for $each (glob("/etc/sysconfig/network-scripts/ifcfg-*"))
{
    print $each."\n";;
    if($each=~/lo$/)
    {next;}

    if (is_static($each))
    {
        print "STATIC:".$each.", skip now \n";
        next;
    }

    my $ip=get_host_ip();
    append_static_lines($each,$ip );
}

########################################################################
# /etc/sysconfig/network-scripts/ifcfg-eno1
sub  is_static($)
{
    (my $cfg_file)=@_;
    open(FILE, $cfg_file)  or die("open $cfg_file error \n");
    for(<FILE>)
    {
        if($_=~/BOOTPROTO.*static/)
        {
            close(FILE);
            return 1; 
        }
    }
    close(FILE);
    return undef;
}

#==========================================================================
sub  get_host_ip()
{
    $buffer=`hostname -I `;
    @array=grep {"192.168."}  split(/\s+/, $buffer);
    return $array[0];
}

#==========================================================================
sub append_static_lines($$)
{
    (my $cfg_file, my $ip )=@_;
    system("sed 's/ONBOOT=no/#ONBOOT=no/g'  -i  $cfg_file " );

    open(APPEND, ">>$cfg_file") or die("open $cfg_file append error \n");
    print APPEND <<EOF

ONBOOT=yes
BOOTPROTO=static
IPADDR=$ip
NETMASK=255.255.255.0
GATEWAY=192.168.1.1
DNS=8.8.8.8
NM_CONTROLLED="no"

EOF
;

}
