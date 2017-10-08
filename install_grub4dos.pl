#!/usr/bin/perl

sub extract_grub4dos()
{
	#解压grub4dos.zip
	if (! -d ("grub4dos-0.4.4"))
	{
		if (-f "C:\\Program Files\\WinRAR\\WinRar.exe")
		{
			if(-f "grub4dos-0.4.4-2009-01-11.zip")
			{
				system('"C:\\Program Files\\WinRAR\\WinRar.exe" x grub4dos-0.4.4-2009-01-11.zip');
				print "解压完成\n";
				logger("grub4dos 解压完成\n");
				return 0;
			}
			else
			{
				return -1;
			}
		}
		else
		{
			logger("winrar 没有安装\n");
			print "检测到WinRAR没有安装在C:\\Program Files\\目录下";
			print "请手动安装WinRAR到C:\\Program Files\\,然后在运行此脚本";
			return -1;
		}
	}

}

sub copy_to_dirC()
{
	system("copy /y grub4dos-0.4.4\\grldr C:\\");
	system("copy /y grub4dos-0.4.4\\menu.lst C:\\");
	if(! -f ("C:\\grldr"))
	{
		logger("拷贝失败，C盘下没有grldr文件\n");
		exit();
	}
	if(! -f ("C:\\menu.lst"))
	{
		logger("拷贝失败，C盘下没有menu.lst文件\n");
		exit();
	}
	else
	{
		logger("grldr menu.lst文件已经拷贝到C盘\n");
		print "grldr menu.lst文件已经拷贝到C盘\n";
	}
}
sub get_boot_ini_content()
{
	open(FILE,"C:\\boot.ini")or logger("when checking,open file boot.ini error\n");
	my $file_content;
	for(<FILE>)
	{
		$file_content .= $_;
	}
	close(FILE);
	return $file_content;
}
sub modify_boot_ini()
{
	system("attrib -R -A -H C:\\boot.ini");	
	my $ret_file_content = get_boot_ini_content();
	if($ret_file_content =~/C:\\grldr=GRUB/)
	{
		logger("C:\grldr=GRUB已经添加到了一次\n");
		print "C:\grldr=GRUB已经添加到了一次\n";
	}
	else
	{
		open(FILE,">>C:\\boot.ini")or logger("when modify,open file boot.ini error\n");#fixme 为什么在函数开始open,文件不可写
		print FILE "C:\\grldr=GRUB\n";
		logger("boot.ini已经修改好\n");
		print  "boot.ini已经修改好\n";
		close(FILE);
	}

}

sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}

	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\grub4dos.log");
	print FILE $log_str;
	close(FILE);
}

if(0 == extract_grub4dos())#解压grub压缩包
{
	copy_to_dirC();		#将grldr menu.lst文件拷贝到C盘
	modify_boot_ini();	#在boot.ini文件添加一行
	#system("del -S -F -Q grub4dos-0.4.4");#  fixme 删除解压出的文件失败	
	unlink("说明_Readme.html");
}
else
{
	print "安装包不存在\n";
	logger("安装包不存在\n");
}
