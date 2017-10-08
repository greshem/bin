#!/usr/bin/perl
use File::Basename;

my $iso=shift or die("Usage: $0 input_winxp.iso \n");

if($iso=~/win7|windows7|window7/i)
{
	gen_win7_floppy($iso);
}

if( $iso=~/win2008|windows2008|window2008|win8/i)
{
	gen_win2008_floppy($iso);
}

if( $iso=~/win2000|windows2000|window2000/i)
{
	gen_win2000_floppy($iso);
}

if($iso=~/winxp|windowsxp/i)
{
	gen_winxp_floppy($iso);
}

if($iso=~/win2003|windows2003/i)
{
	gen_win2003_floppy($iso);
}



sub gen_win2000_floppy($iso)
{

	(my $win2000_iso)=@_;
	my $suffix=basename($win2000_iso);
	$suffix=~s/\.iso$//g;

	gen_winxp_winnt_sif();

	system("dd if=/dev/zero of=floppy_win2000.img bs=1024 count=1440 ");
	system("mkdosfs -F 12 floppy_win2000.img \n");
	mkdir("dir/");
	system(" mount -t vfat floppy_win2000.img dir/  -o loop ");
	system("cp winnt_xp.sif dir/winnt.sif");
	system("cp /root/bin/kickstart/AutoUnattend_2000.xml   dir/");	
	system("umount dir/");

	if( -f "floppy_win2000.img")
	{
		print "#generate  floppy_win2000.img  OK \n";

	}




	open(INSTALL, ">install_win2000.sh") or die("create install_win2000.sh error \n");
	print INSTALL <<EOF
set -x 
qemu-img create -f qcow2 win2000_cn_sp3.img  20g

qemu-kvm  -fda floppy_win2000.img -enable-kvm  -cdrom  $win2000_iso    -drive file=win2000_cn_sp3.img,cache=writeback    -localtime   -usb -usbdevice tablet  -net nic,macaddr=DC:0E:2A:B8:4E:F9    -vnc 0.0.0.0:0  -boot d -m 1024 


EOF
;

}

sub gen_win2008_floppy($)
{

	(my $win2008_iso)=@_;

	my $suffix=basename($win2008_iso);
	$suffix=~s/\.iso$//g;

	system("dd if=/dev/zero of=floppy_win2008.img bs=1024 count=1440 ");
	system("mkdosfs -F 12 floppy_win2008.img \n");
	mkdir("dir/");
	system(" mount -t vfat floppy_win2008.img dir/  -o loop ");
	system("cp winnt_xp.sif dir/winnt.sif");
	system("cp /root/bin/kickstart/AutoUnattend_2008.xml   dir/");	
	system("cp /root/bin/kickstart/AutoUnattend_2008.xml   dir/AutoUnattend.xml");	
	system("umount dir/");

	if( -f "floppy_win2008.img")
	{
		print "#generate  floppy_win2008.img  OK \n";

	}


	open(INSTALL, ">install_win2008.sh") or die("create install_win2008.sh error \n");
	print INSTALL <<EOF
set -x 

qemu-img create -f qcow2 win2008_cn_sp3.img  20g

qemu-kvm  -fda floppy_win2008.img -enable-kvm  -cdrom  $win2008_iso    -drive file=win2008_cn_sp3.img,cache=writeback    -localtime   -usb -usbdevice tablet  -net nic,macaddr=DC:0E:2A:B8:4E:F9    -vnc 0.0.0.0:0  -boot d -m 1024 


EOF
;

}


sub gen_win7_floppy($)
{


	(my $win7_iso)=@_;

	my $suffix=basename($win7_iso);
	$suffix=~s/\.iso$//g;

	system("dd if=/dev/zero of=floppy_win7.img bs=1024 count=1440 ");
	system("mkdosfs -F 12 floppy_win7.img \n");
	mkdir("dir/");
	system(" mount -t vfat floppy_win7.img dir/  -o loop ");
	system("cp winnt_xp.sif dir/winnt.sif");
	system("cp /root/bin/kickstart/AutoUnattend.xml   dir/");	
	system("umount dir/");

	if( -f "floppy_win7.img")
	{
		print "#generate  floppy_win7.img  OK \n";

	}


	open(INSTALL, ">install_win7.sh") or die("create install_win7.sh error \n");
	print INSTALL <<EOF
set -x 

qemu-img create -f qcow2 win7_cn_sp3.img  20g

qemu-kvm  -fda floppy_win7.img -enable-kvm  -cdrom  $win7_iso    -drive file=win7_cn_sp3.img,cache=writeback    -localtime   -usb -usbdevice tablet  -net nic,macaddr=DC:0E:2A:B8:4E:F9    -vnc 0.0.0.0:0  -boot d -m 1024 


EOF
;

}


sub gen_win2003_floppy($)
{
	(my $win2003_iso)=@_;

	my $suffix=basename($win2003_iso);
	$suffix=~s/\.iso$//g;

	system("dd if=/dev/zero of=floppy_win2003_$suffix.img bs=1024 count=1440 ");
	system("mkdosfs -F 12 floppy_win2003_$suffix.img \n");
	gen_winxp_winnt_sif();
	
	mkdir("dir/");
	system(" mount -t vfat floppy_win2003_$suffix.img dir/  -o loop ");
	system("cp winnt_xp.sif dir/winnt.sif");
	system("umount dir/");

	if( -f "floppy_win2003_$suffix.img")
	{
		print "#generate  floppy_win2003_$suffix.img  OK \n";

	}


	open(INSTALL, ">install_win2003_$suffix.sh") or die("create install_win2003.sh error \n");
	print INSTALL <<EOF
set -x 

qemu-img create -f qcow2 win2003_cn_sp3_$suffix.img  20g

qemu-kvm  -fda floppy_win2003_$suffix.img -enable-kvm  -cdrom  $win2003_iso    -drive file=win2003_cn_sp3_$suffix.img,cache=writeback    -localtime   -usb -usbdevice tablet  -net nic,macaddr=DC:0E:2A:B8:4E:F9    -vnc 0.0.0.0:0  -boot d -m 1024 


EOF
;
}



sub gen_winxp_floppy($)
{
	(my $winxp_iso)=@_;

	my $suffix=basename($winxp_iso);
	$suffix=~s/\.iso$//g;

	system("dd if=/dev/zero of=floppy_winxp_$suffix.img bs=1024 count=1440 ");
	system("mkdosfs -F 12 floppy_winxp_$suffix.img \n");
	gen_winxp_winnt_sif();
	
	mkdir("dir/");
	system(" mount -t vfat floppy_winxp_$suffix.img dir/  -o loop ");
	system("cp winnt_xp.sif dir/winnt.sif");
	system("umount dir/");

	if( -f "floppy_winxp_$suffix.img")
	{
		print "#generate  floppy_winxp_$suffix.img  OK \n";

	}


	open(INSTALL, ">install_winxp_$suffix.sh") or die("create install_winxp.sh error \n");
	print INSTALL <<EOF
set -x 

qemu-img create -f qcow2 winxp_cn_sp3_$suffix.img  20g

qemu-kvm  -fda floppy_winxp_$suffix.img -enable-kvm  -cdrom  $winxp_iso    -drive file=winxp_cn_sp3_$suffix.img,cache=writeback    -localtime   -usb -usbdevice tablet  -net nic,macaddr=DC:0E:2A:B8:4E:F9    -vnc 0.0.0.0:0  -boot d -m 1024 


EOF
;
	printf(" bash install_winxp_$suffix.sh \n");
}


sub gen_winxp_winnt_sif()
{
	open(FILE, ">winnt_xp.sif")  or die("create winxp_xp.sif error \n");
	print FILE  <<EOF
[Data]
AutoPartition=1
MsDosInitiated="0"
UnattendedInstall="Yes"

[Unattended]
UnattendMode=FullUnattended
OemSkipEula=Yes
OemPreinstall=No
TargetPath=WINDOWS
Repartition=Yes
UnattendSwitch=Yes
DriverSigningPolicy=Ignore

[GuiUnattended]
AdminPassword=*
EncryptedAdminPassword=No
OEMSkipRegional=1
TimeZone=210
OemSkipWelcome=1
ServerWelcome=No
EMSSkipUnattendProcessing=0
EMSBlankPassword=Yes 

[UserData]
ProductKey="GR9V3-FX3XQ-HJHX2-H46JF-GFHXB"
FullName="bbbbb"
OrgName=""
ComputerName=*

[LicenseFilePrintData]
AutoMode=PerServer
AutoUsers=5

[Identification]
JoinWorkgroup=WORKGROUP

[Networking]
InstallDefaultComponents=Yes

[Branding]
BrandIEUsingUnattended=Yes

[Display]
BitsPerPel=32
XResolution=800
YResolution=600

[GuiRunOnce]
;Command0="cmd /c copy a:\upgrader.exe %TEMP%\upgrader.exe"
;Command1="cmd /c copy a:\unattend.cmd %TEMP%\unattend.cmd"
;Command2="cmd /c copy a:\storePwd.exe %TEMP%\storePwd.exe"
;Command3="cmd /c copy a:\storePwd.ini %TEMP%\storePwd.ini"
;Command4="%TEMP%\unattend.cmd noautoreboot"

[VMwareData]
RunCmdKey=Command4
RunCmdNoReboot="%TEMP%\unattend.cmd noautoreboot"

EOF
;
	close(FILE);
}



%sn=(
"win2003_i386"=> "JCDPY-8M2V9-BR862-KH9XB-HJ3HM",
);
