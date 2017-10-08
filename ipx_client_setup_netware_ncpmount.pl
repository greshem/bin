#!/usr/bin/perl

sub get_network()
{
	open(FILE, "/proc/net/ipx/interface") or die("open file error\n");
	for(<FILE>)
	{
		@array=split(/\s+/, $_);
		#print join("|", @array)."\n";;
		if($array[0]!~/network/i)
		{
			return $array[0];
		}
	}
}
sub print_usage()
{
	foreach (<DATA>)
	{
		print $_;
	}
}
########################################################################
#SERVER                                              00004444  000000000001
sub get_server_name()
{
	open(FILE, "slist |")or die("open pipe error\n");
	for(<FILE>)
	{
		@array=split(/\s+/,$_);
		return $array[0];
	}
}


print "#���ع���nwfs\n";
$network=get_network();
print "#Network ".$network."\n";
print "ipx_interface add -p eth0 802.2 0x".$network."\n";
$server= get_server_name();
print "Server: ".$server."\n";

mkdir("/mnt/nwfs");
print "#ncpmount -S ".$server."    -U root    /mnt/nwfs \n";
print " ncpmount -S ".$server."    -U supervisor    /mnt/nwfs \n";


#print_usage();
__DATA__

#2011_02_23_14:04:04 add by greshem
windows �¹�������.
  net use n: \\server\sys /u:supervisor 123456
  net use * /delete


#2010_12_13_ add by greshem
1. 
��������
cat /proc/net/ipx/interface

Network    Node_Address   Primary  Device     Frame_Type
2B43A245   000000000001   Yes      Internal   None     
20100915   842B2B5E41CB   No       eth0       802.2    
//########################################################################

2.  �ͻ����� 
�� 20100915 �ڶ�����ַ��  
ipx_interface add -p eth0 802.2 0x20100915
֮�� slist �Ϳ����г� ��������. 

 ncpmount -S GFTEST    -U root    /media/disk 
�Ϳ��Թ�����. 

//########################################################################
ncpmount -S HQ -U SUPERVISOR -P 123456 /media/disk

