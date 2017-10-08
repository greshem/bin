#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

mkdir  /mnt/cifs_rtiosrv/
mount -t cifs rtiosrv:/_tmp/ /mnt/cifs_rtiosrv/


cd /mnt/cifs_rtiosrv/
mount -t ntfs  -o loop,offset=$((64*512))  VMWARE.IMG   /mnt/VMWARE/ 

cd /mnt/VMWARE/WINDOWS/system32/config/
/bin/hivex_reg_usage.pl 


cd /mnt/VMWARE/WINDOWS/system32/drivers/



#==========================================================================
#from richboot.sys
hivexregedit  --unsafe-printable-strings --export System  \\ControlSet001\\Services\\richboot 
hivexregedit  --unsafe-printable-strings --export System  \\ControlSet001\\Services\\richdisk 
hivexregedit  --unsafe-printable-strings --export System  \\ControlSet001\\Services\\richndis
hivexregedit  --unsafe-printable-strings --export System  \\ControlSet001\\Control\\ComputerName\\ComputerName
hivexregedit  --unsafe-printable-strings --export System  \\ControlSet001\\Control\\ComputerName\\ActiveComputerName
hivexregedit  --unsafe-printable-strings --export System  \\ControlSet001\\Services\\Tcpip\\Parameters
#BootExecute
hivexregedit  --unsafe-printable-strings --export System  "\\ControlSet001\\Control\\Session Manager"
hivexregedit  --unsafe-printable-strings --export System  \\ControlSet001\\Enum\\STORAGE\\Volume

#win7 related regkeys
