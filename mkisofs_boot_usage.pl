#!/usr/bin/perl
use strict;
if($0=~/mkisofs_usage.pl$/)
{
	if(  ! -f "isolinux/isolinux.bin")
	{
		die("当前目录不很生成 可启动 光盘\n");
	}

	del_discinfo_file();
	if(! -f  "isolinux/isolinux.cfg")
	{
		gen_isolinux_cfg("isolinux/isolinux.cfg");
	}
	create_ks_cfg("isolinux/ks.cfg.template.template.cfg");
	mkisofs_cmd();
}
########################################################################
sub del_discinfo_file()
{
	if( -f ".discinfo")
	{
		system("rm .discinfo ");  #bug  1h , 这个很重要, 一定要删除掉.
	}
}

sub gen_isolinux_cfg($)
{
	(my $output_cfg)=@_;
	open(ISO_CFG, " >$output_cfg ") or die("create isolinux/isolinux.cfg error\n");

	print ISO_CFG "default linux\n";
	print ISO_CFG "prompt 0\n";
	print ISO_CFG "timeout 1\n";
	print ISO_CFG "\n";
	print ISO_CFG "label linux\n";
	print ISO_CFG "       kernel vmlinuz\n";
	print ISO_CFG "       append initrd=initrd.img  ks=cdrom:/isolinux/ks.cfg\n";

	close(ISO_CFG);
}

sub create_ks_cfg()
{
	(my $output_ks_cfg)=@_;
	open(KS_CFG, " > $output_ks_cfg") or die("create isolinux/ks.cfg error\n");
	print KS_CFG <<EOF
lang en_US
#langsupport --default en_US
network --bootproto dhcp
cdrom
keyboard us
zerombr yes
clearpart --all --initlabel
part /boot --size 300
part swap --recommended
part / --size 8000 --grow
#part biosboot --fstype=biosboot --size=1
install
#mouse generic3ps/2
firstboot --disable
firewall --enabled
timezone --utc America/Los_Angeles
xconfig --startxonboot --resolution=800x600
rootpw --iscrypted \$1\$i\$t0wRMv6IEEc12OsQeqPpN1
reboot
auth --useshadow --enablemd5
bootloader --location=mbr
#key --skip
%packages
python
@ X Window System
@ GNOME Desktop Environment
@ Graphical Internet
@ Development Tools
#@ Fonts  , not in fedora6 

%end
%post
%end

EOF
;
	close(KS_CFG);
}

sub mkisofs_cmd()
{
	use Cwd;
	my $pwd=getcwd();
	print "#".$pwd."\n";;

	use File::Basename;
	my $targetname=basename($pwd);

	if($^O=~/win/i)
	{
	print <<EOF
#check dvd os version 
#/bin/cp_with_dir_v3.pl 

mkisofs -r -N -L -d -J -T -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot  -V "$targetname" -boot-load-size 4 -boot-info-table  -o ../${targetname}_autoinst.iso .

EOF
;

	}
	else
	{
	print <<EOF
#check dvd os version 
#/bin/cp_with_dir_v3.pl 

mkisofs -r -N -L -d -J -T -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot  -V "$targetname" -boot-load-size 4 -boot-info-table  -o /tmp/${targetname}_autoinst.iso $pwd  

EOF
;

	}
}
