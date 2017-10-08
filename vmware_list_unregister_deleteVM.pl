#!/usr/bin/perl

# vmlist5.config = "E:\vmware_app_linux\freenas\freenas.vmx"
# vmlist5.DisplayName = "freenas"
# vmlist5.ParentID = "0"
# vmlist5.ItemID = "5"
# vmlist5.SeqID = "0"
# vmlist5.IsFavorite = "FALSE"
# vmlist5.IsClone = "FALSE"
# vmlist5.CfgVersion = "8"
# vmlist5.State = "normal"
# vmlist5.UUID = "56 4d 07 c3 1a 2e d4 93-3a 25 05 5e 59 b1 8e 41"

my %hash;
my $vmx;
open(FILE, "C:\\Users\\Administrator\\AppData\\Roaming\\VMware\\inventory.vmls") or die("vmls not exists \n");
for(<FILE>)
{
	my $name;
	if($_=~/.*config.*=.*"(.*)"/)
	{
		$vmx=$1	;
		#print "vmx=$vmx \n";
	}
	elsif($_=~/.*DisplayName.*=.*\"(.*)\"/)
	{
		$name=$1;
		$hash{$name}=$vmx;
		if( ! -f $vmx)
		{
			print "#$name not exists  \n";
		   	print "vmrun.exe -T ws  deleteVM   	$vmx \n";
			print "vmrun.exe -T ws  unregister       $vmx \n"; 
		}
		else
		{
			print "#$name OK   \n";
					   	print "vmrun.exe -T ws  deleteVM   	$vmx \n";
			print "vmrun.exe -T ws  unregister       $vmx \n"; 
		}


	}
}
