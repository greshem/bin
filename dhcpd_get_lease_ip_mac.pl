#!/usr/bin/perl 
# for each in $(cat /var/lib/dhcp/dhcpd.leases |grep ^lease |sort |uniq |awk '{print $2}')
# do
# echo reboot $each 
# echo  reboot -f |sbd -w 1 $each 45
# done




#从 dhcpd.release 文件里面获取 ip mac name 
#	返回匿名的hash.
sub get_hash_from_dhcpd_lease($)
{
	$ini={};
	my $ip;
	my $mac;
	my $name;

	(my $lease)=@_;
	print "#deal with   $lease \n"; 
	open(LEASE, $lease)  or die("open $lease error $! \n");
	for(<LEASE>)
	{
		if($_=~/^lease\s+(\S+)\s+{/)
		{
			$ip=$1;
			#print $ip."\n";
		}
		if($_=~/\s*hardware\s+ethernet\s+(\S+);/)
		{
			$mac=$1;
			#print $mac."\n";
		}
		if($_=~/\s*client-hostname\s+"(\S+)";/)
		{
			$name=$1;
			#print $name."\n";
		}
		if($_=~/^}/)
		{
			#print $ip."\t".$mac."\t".$name."\n";
			$ini->{$mac}->{"ip"}=$ip;
			$ini->{$mac}->{"mac"}=$mac;
			$ini->{$mac}->{"hostname"}=$hostname;
			#print "##".$ip."\n";
			#print_wks_ini($ip, $mac, $name);
			$ip=$mac=$name=undef;	
		}
	}

	return $ini;
}
sub print_wks_ini($$$)
{
	(my $ip, $mac, $name)=@_;
print <<EOF	
[$mac]
WksName=$name
IpAddr=$ip
Enable=1
Netmask=255.255.255.0
Gateway=
BootCard=
BootDisk=VM*0
BootServer=
WksGroup=
WksPath=/tmp/
DNSMaster=
DNSSubman=
RemoteBoot=1
ClientCache=0
HotBackup=0
UserSelect=0
MenuBootHD=1
DiskGroup=
Memo=
EOF
;

}

########################################################################
#从系统的 dhcpd.conf 里面获取 名字 ip mac 的对应的关系.
#返回值 1. 匿名hash
#		2.  另外的include文件. 现在不用了.
our @g_ip_name_mac;
sub get_hash_from_dhcpd_conf($)
{
	(my $conf)=@_;
	my @includes_file;
	my $ini={};
	#$conf="/etc/dhcp/dhcpd.conf";
	print "deal with  $conf \n"; 
	open(CONF, $conf)  or die("open $conf error $! \n");
	for(<CONF>)
	{
		if($_=~/host\s+(\S+)\s+\{\s+hardware\s+ethernet\s+(\S+);\s+fixed-address\s+(\S+);/)
		{
			$name=$1;
			$mac=$2;
			$ip=$3;
			$ini->{$mac}->{"ip"}=$ip;
			$ini->{$mac}->{"mac"}=$mac;
			$ini->{$mac}->{"name"}=$name;
			$ip=$mac=$name=undef;	
		}
		if($_=~/include\s*\"(.*)\"/)
		{
			print "#include file $1\n";
			push(@includes_file, $1);
		}
	}
	close(CONF);
	return ($ini, @includes_file);
}

if($0=~/dhcpd_get_lease_ip_mac.pl$/)
{
	my $leases= "/var/lib/dhcpd/dhcpd.leases";
	my $hash = get_hash_from_dhcpd_lease($leases);
	foreach (keys(%{$hash}))
	{
		print "[$_]\n";
		print "ip = ".$hash->{$_}->{"ip"}."\n";
		print "mac = ".$hash->{$_}->{"mac"}."\n";
		print "name = ".$hash->{$_}->{"name"}."\n";
	}

	(my $ini,my  @includes)=get_hash_from_dhcpd_conf("/etc/dhcpd.conf");
	foreach (keys(%{$ini}))
	{
		print "[$_]\n";
		print "ip = ".$ini->{$_}->{"ip"}."\n";
		print "mac = ".$ini->{$_}->{"mac"}."\n";
		print "name = ".$ini->{$_}->{"name"}."\n";
	}

	# for(@includes)
	# {
	# 	get_ip_mac_name_from_file($_);
	# }
}
