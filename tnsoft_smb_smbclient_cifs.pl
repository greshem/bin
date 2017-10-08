#!/usr/bin/perl
use strict; 
our $g_ip =shift  	or Usage();
my $user=shift 		or Usage();
my $passwd=shift    or Usage();


if($user!~/\\/)
{
	warn("WARN: tnsoft smb user active directory,  need domain \n");	
}

$user=~s/\\/\\\\/g;
my @shares= get_shared_name($user, $passwd);


for(@shares)
{
	print "mkdir \"/mnt/smbfs/$_\"\n";
	print  "mount.cifs -o username=$user,password=$passwd,ro   \"//$g_ip/$_\"  \"/mnt/smbfs/$_\"  \n";
}

########################################################################
#subfunction 
sub get_shared_name($$)
{
	(my $user, my $passwd)=@_;;
	#$user=~s/\\/\\\\/g;
	my @share_names;
	my $cmd_str= "smbclient  -L    $g_ip -U $user%$passwd ";
	print $cmd_str."\n";
	open(PIPE, "  $cmd_str |") or die("exec  smbclient   error $!\n");
	for(<PIPE>)
	{
		if($_=~/Disk|IPC/)
		{
			my @array=split(/\s+/, $_);
			my $name= $array[1];
			#print $name."\n";
			push(@share_names, $name );
		}
	}
	return (@share_names);

}
sub Usage()
{
	print ("Usage: ip user passwd \n");
	print ("perl $0 172.16.1.18  tnsoft\\\\zjqian  q***************n\n");
	print ("perl $0 192.168.1.12  administrator   q***************n\n");
	die("\n");
}

#==========================================================================

__DATA__
   Employe-Storage Disk      
        G$              Disk      Default share
        HR              Disk      
        HR\&Admin        Disk      
        HR_Intern       Disk      
        IPC$            IPC       Remote IPC
