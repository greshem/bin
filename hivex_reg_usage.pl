#!/usr/bin/perl
#2012_01_30_12:13:34   ����һ   add by greshem
#==========================================================================
use Cwd;
$dir=getcwd;
if($dir=~/config$/i)
{
	win_reg_files()
}
else
{
	common_usage();
	print "#################################\n";
	win_reg_copy_out_files();
}

#Deal with the hive file, copy out from winxp system32/config dir, and with suffix .bin
sub win_reg_copy_out_files()
{
	for (qw(SAM.bin SECURITY.bin System.bin   default.bin  software.bin  userdiff.bin ))
	{
		if(-f $_)
		{
			($name)=($_=~/(.*).bin/);
			print "hivexregedit --export $_ \\\\ >  $name.reg \n";
			print "hivexregedit --export $_  --unsafe-printable-strings \\\\ >  $name.safe.reg \n";
			print "hivexregedit --merge  $_ <  $name.reg \n";
		}
	}	
}

sub win_reg_files()
{
	if(! -d "/tmp/config_reg")
	{
		mkdir("/tmp/config_reg");
	}

	for (qw(SAM SECURITY System   default  software  userdiff  system SYSTEM ))
	{
		if(-f $_)
		{
			print "hivexregedit --export $_ \\\\ >  /tmp/config_reg/$_.reg \n";
			print "hivexregedit --export $_  --unsafe-printable-strings \\\\ >  /tmp/config_reg/$_.safe.reg \n";
			print "hivexregedit --merge  $_ <  /tmp/config_reg/$_.reg \n";
		}
	}	


}
#==========================================================================
sub common_usage()
{
print <<EOF
#���İ�װ.
yum install hivex
#dump all
hivexregedit --export  software \\ #��windows �µ�ע���Ŀ¼, ע�� ��·�� ��\\ 
#��ص�һ����� chntpw-0.99.6-13.fc12.src.chm,ʵ�� ������hivex ���.

hivexregedit --export default \\  #ע���·����д��.

#==========================================================================
ע��� merge
1. �ж� �ļ���ʽ  software.reg: Little-endian UTF-16 Unicode text, with very long lines,
	���������ֶ� ��Ҫ ת��.
  iconv -f utf-16le -t utf-8 < win.reg | dos2unix > linux.reg
  unix2dos linux.reg | iconv -f utf-8 -t utf-16le > win.reg
	 

#==========================================================================
hivexregedit --export System \\ >  /tmp/System.reg 
#edit
hivexregedit --merge  System     <  /tmp/System.reg 

EOF
;
}
