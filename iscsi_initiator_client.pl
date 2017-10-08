#!/usr/bin/perl
#$portal="172.16.101.30:3260";
#my $portal=shift or die("Usqage: $0  x.x.x.x:3260\n");

my $ip=`hostname -I  | awk '{print \$1}' `;
chomp ($ip);
$portal="$ip:3260";
#发现服务器的磁盘,

print  <<EOF
########################################################################
########################################################################
iscsiadm -m discovery -t sendtargets -p $portal
iscsiadm --mode discovery --type sendtargets --portal  $portal 
EOF
;

my $cmd_str="iscsiadm -m discovery -t sendtargets -p $portal";
my $str= `iscsiadm -m discovery -t sendtargets -p $portal`;


print "CMD_EXEC: ".$cmd_str."\n";
print $str

my @array=split(/\s+/ , $str);
print join("|||||||", @array)."\n";

for $each (@array)
{
	my $targetname=$each;
	print <<EOF
	#=======================================================================
	iscsiadm --mode node 

	#login , deal in  kernel 
	iscsiadm -m node   loginall=all
	iscsiadm --mode node --targetname $targetname  --portal $portal --login

	#logout
	#iscsiadm --mode node --targetname $targetname  --portal $portal  --logout
	#

EOF
;
}

sub get_target_name()
{
}
