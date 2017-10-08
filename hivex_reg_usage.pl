#!/usr/bin/perl
#2012_01_30_12:13:34   星期一   add by greshem
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
#包的安装.
yum install hivex
#dump all
hivexregedit --export  software \\ #到windows 下的注册表目录, 注意 根路径 是\\ 
#相关的一个软件 chntpw-0.99.6-13.fc12.src.chm,实现 基本和hivex 差不多.

hivexregedit --export default \\  #注意根路径的写法.

#==========================================================================
注册表 merge
1. 判断 文件格式  software.reg: Little-endian UTF-16 Unicode text, with very long lines,
	有这样的字段 需要 转换.
  iconv -f utf-16le -t utf-8 < win.reg | dos2unix > linux.reg
  unix2dos linux.reg | iconv -f utf-8 -t utf-16le > win.reg
	 

#==========================================================================
hivexregedit --export System \\ >  /tmp/System.reg 
#edit
hivexregedit --merge  System     <  /tmp/System.reg 

EOF
;
}
