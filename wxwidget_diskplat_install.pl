#!/usr/bin/perl
#svnd it in  /root/bin 
use strict;
my $command=shift;
my $g_wx_version="2.8.10";
if( ! -f "/usr/bin/gcc"  ||  !  -f "/usr/bin/vim" )
{
	cdrom_check();
	yum_install_package();
}
else
{
	print "#compiler env is ok \n";
	print "#gcc is ok, will not yum install package \n";
}

copy_file_to_dir();
if(!defined($command))
{
	install_wxwidgets();
	#install_diskplat();
}
elsif($command=~/^w/i)
{
		install_wxwidgets();
}
elsif($command=~/^d/i)
{		
	install_diskplat();
}


########################################################################
sub copy_file_to_dir()
{
	if( -f  "./wxWidgets-${g_wx_version}.tar.gz")
	{
		system_exec_must_success_or_die("cp -f  ./wxWidgets-${g_wx_version}.tar.gz /home/works/");
	}
	if( -f "./diskplat_build1181.zip")
	{
		system_exec_must_success_or_die("cp -f ./diskplat_build1181.zip  /home/works/");
	}
	if( -f "./repo_local_disk_yum.pl")
	{
		system_exec_must_success_or_die("cp -f repo_local_disk_yum.pl  /bin/");
	}
	if( -f "wxwidget_diskplat_install.pl")
	{
		system_exec_must_success_or_die("cp -f wxwidget_diskplat_install.pl   /bin/");
	}

	chdir_must_success_or_die("/home/works/");
	if( -f "/home/works/diskplat_build1181.zip")
	{
		system_exec_must_success_or_die("unzip -o  /home/works/diskplat_build1181.zip ");
	}
}
#do("./shell_common_cmd_exec_or_die.pl");
sub cdrom_check()
{
	system(" dd if=/dev/cdrom  of=/tmp/tmp.img bs=4K count=2   ");
	if($?>>8 ne 0)
	{
		warn ("rm -f   /dev/cdrom \n");
		warn ("ln -s /dev/cdrom-hda  /dev/cdrom \n");
		my_die("#cdrom , can't readabled , please insert rhel iso   \n");
	}
}


sub yum_install_package()
{
	system("mkdir -p /tmp/dir ");
	if( ! -f "/tmp/dir/.discinfo")
	{
		system_exec_must_success_or_die("mount -t iso9660 /dev/cdrom /tmp/dir/ ");
	}


	 
	system_exec_must_success_or_die("mkdir -p /etc/yum.repos.d/back ");
	system("mv /etc/yum.repos.d/* /etc/yum.repos.d/back/ ");
	if( is_centos())
	{	
		system_exec_must_success_or_die("/bin/repo_local_disk_yum.pl /tmp/dir/ ");
	}
	else
	{
		system_exec_must_success_or_die("/bin/repo_local_disk_yum.pl /tmp/dir/Server/ ");
	}

	if( is_rhel_5_1() ||  is_rhel_5_0() )
	{
		if(! -f "/have_createrepo_rhel_0")	
		{
		system("rpm -ivh /tmp/dir/Server/createrepo*rpm ");
		system_exec_must_success_or_die("createrepo  -o /etc/yum/ -g /tmp/dir/Server/repodata/comps-rhel5-server-core.xml /tmp/dir/Server/ ");
		system_exec_must_success_or_die("mount --bind /etc/yum/repodata/ /tmp/dir/Server/repodata/");
		system_exec_must_success_or_die("yum clean all ");
		system_exec_must_success_or_die("yum makecache ");
		system_exec_must_success_or_die("touch /have_createrepo_rhel_0");

		}
		else
		{
			print ("#have createrepo in rhel_5_0 \n");
		}

	}



	system_exec_must_success_or_die(" yum -y  install gtk\\* vim\\* subversion libusb\\* gcc\\* font\\*  xorg-x11-font\\*  gdb\\*  xinetd\\* tftp\\* dhcp\\* nmap iptraf iptraf-ng bison flex  perl-DBI perl-DBD-SQLite");
}

sub install_wxwidgets()
{

	if(! -f "/usr/bin/wx-config")
	{
		wxwidgets_download_suggest();
		
		if(-f  "/home/works/wxWidgets-${g_wx_version}.tar.gz")
		{
			system_exec_must_success_or_die("tar -xzf /home/works/wxWidgets-${g_wx_version}.tar.gz -C /home/works/ ");
		}

		if( ! -d "/home/works/wxWidgets-${g_wx_version}/")
		{
			die("# wxWidgets-${g_wx_version}.tar.gz cannot extract, dir is read only ?  \n");
		}

		my $count= `  find /home/works/wxWidgets-${g_wx_version} |wc -l `;
		if($count < 8000)
		{
			my_die("Error:  source code file less then 10000 \n");
		}

		#假如没有  wxSOCKET_BROADCAST   就是 wxwidgets 的子版本号不对了.
		system_exec_must_success_or_die("grep    wxSOCKET_BROADCAST   /home/works/wxWidgets-${g_wx_version}/include/wx/socket.h");

		system_exec_must_success_or_die("mkdir /home/works/wxWidgets-${g_wx_version}/buildgtk  -p ");
		chdir_must_success_or_die("/home/works/wxWidgets-${g_wx_version}/buildgtk");
		system_exec_must_success_or_die("../configure --with-gtk --enable-unicode --disable-shared ");
		system("sed '/^CC =/{s/\$/ -g/g}'  Makefile -i ");
		system("sed '/^CXX =/{s/\$/ -g/g}'  Makefile -i ");
		system_exec_must_success_or_die("make");
		system_exec_must_success_or_die("make install ");
		#cd /etc/ld.so.conf.d
		chdir_must_success_or_die("/etc/ld.so.conf.d/");
		system_exec_must_success_or_die("echo \"/usr/lib\" > wx.conf ");
		system_exec_must_success_or_die("ldconfig ");
	}
	else
	{
		print ("# wxwidgets-${g_wx_version}  have installed \n");
	}
}

########################################################################
#开始开出处理diskplat_buildxxx.tar.gz 的编译工作. 
#my @diskplat_targz=glob("/home/works/diskplat_build*");
#if(scalar(@diskplat_targz
sub install_diskplat()
{
	chdir_must_success_or_die("/home/works/diskplat/trunk/");
	system_exec_must_success_or_die("chmod +x /home/works/diskplat/trunk/tools_hangyue/ -R  ");
	system_exec_must_success_or_die("perl install_hangyue.pl ");
	system_exec_must_success_or_die("make -f Makefile_linux_debug install ");
	system_exec_must_success_or_die("perl install_hangyue.pl ");
}


#磁盘空间.
########################################################################
# sub system_exec_must_success_or_die($)
# sub rmrf_dir($)
# sub my_die($)
# sub chdir_must_success_or_die($)
# sub mkdir_if_not_exist_or_die($)
# sub dir_must_exist_or_die($)
# sub dir_must_not_exist($)
# sub file_must_exist($)




########################################################################
#subfuction 
#最简单的.

sub wxwidgets_download_suggest()
{
	if( ! -f "/home/works/wxWidgets-${g_wx_version}.tar.gz" )
	{
		print<<EOFPERL
	lftp home/works\@192.168.0.100:/sdb1/_xfile/2012_all_iso/_xfile_201210/_d_frequent_1/ <<EOF
	get wxWidgets-${g_wx_version}.tar.gz
	EOF

	wget  http://easymule.googlecode.com/files/wxWidgets-${g_wx_version}.tar.gz
	wget  http://prdownloads.sourceforge.net/wxwindows/wxWidgets-${g_wx_version}.tar.gz
	wget  http://ftp.heanet.ie/pub/download.sourceforge.net/pub/sourceforge/w/wx/wxwindows/wxAll/${g_wx_version}/wxWidgets-${g_wx_version}.tar.gz
EOFPERL
;
		die("please download this file  wxwidgets-${g_wx_version}.tar.gz\n");
	}
}

sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /home/works/wxwidgets_compiler.log") or warn("open all.log error\n");
	print $log_str;
	print FILE $log_str;
	close(FILE);
}

sub my_die($)
{
	(my $log_str)=@_;
	$log_str="错误:".$log_str;
	logger($log_str);
	die($log_str);
}

sub system_exec_must_success_or_die($)
{
	(my $cmd_str)=@_;
	logger("执行命令: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die("命令行: $cmd_str 执行失败\n");
	}
}


sub chdir_must_success_or_die($)
{
	(my $dir)=@_;

	if(! chdir($dir))
	{ 
		my_die("$dir  目录不次存在\n"); 
	}
}


sub mkdir_if_not_exist_or_die($)
{
	(my $dir)=@_;
	if(-d $dir)
	{
		logger(" $dir 已经生成过了,不用再生成了\n");
	}
	else
	{
		mkdir($dir);
	}
}
sub dir_must_exist_or_die($)
{
	(my $dir)=@_;
	#print "Deal With: ".$dir."\n";
	if(! -d $dir)
	{
		my_die("PANIC: $dir 应该存在, 但是不存在, \n");
	}
}
sub dir_must_not_exist($)
{
	(my $dir)=@_;
	if( -d $dir)
	{
		my_die("PANIC: $dir  应该不存在, 但是存在了. \n");
	}
}

sub file_must_exist($)
{
	(my $file)=@_;
	if(! -f $file)
	{
		my_die("PANIC: $file 文件不存在, \n");
	}
}
sub is_centos()
{	
	my $buf=file_get_contents("/etc/issue");
	if($buf=~/centos/i)
	{
		return 1;
	}

	return undef;
}
sub is_rhel_5_1()
{
	my $buf=file_get_contents("/etc/issue");
	if($buf=~/5.0/)
	{
		return 1;
	}		
	return undef;
}

sub is_rhel_5_0()
{
	my $buf=file_get_contents("/etc/issue");
	if($buf=~/Tikanga/)
	{
		return 1;
	}		
	return undef;
}


sub file_get_contents($)
{
	(my $filename)=@_;
	open(FILE, $filename);
	$/=undef;
	my $string=(<FILE>);
	close(FILE);
	$/="\n";
	return  $string ;
}

