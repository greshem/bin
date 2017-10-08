#!/usr/bin/perl

our	@g_wx_path=qw(C:\\wxWidgets-2.8.10\\
	C:\\works\\wxWidgets-2.8.10\\
	D:\\works\\wxWidgets-2.8.10\\
	D:\\tmp\\wxWidgets-2.8.10\\
	D:\\wxWidgets-2.8.10\\
	E:\\tmp\\wxWidgets-2.8.10\\
	E:\\works\\wxWidgets-2.8.10\\
	E:\\wxWidgets-2.8.10\\
	/tmp9/wxWidgets-2.8.11/
	);

sub get_wxWidgets_working_path()
{


	for $each (@g_wx_path)
	{
		#print $each."\n";
		if(-d $each)
		{
			print "cd  $each  \n";
			return $each
		}
	}
	return undef;
}

########################################################################
sub cleanup($)
{	
	(my $workpath)=@_;
	chdir($workpath."\\build\\msw");
	system("nmake /f  makefile.vc clean");

	for $each (@g_wx_path)
	{
		#print $each."\n";
		if(-d $each)
		{
			print "rm -rf  $each\n";
		}
	}
	exit(-1);
}
########################################################################
sub compile_with_nmake($)
{
	(my $workpath)=@_;
	chdir($workpath);

	if( -d   $workpath."\\build\\msw")
	{
		chdir($workpath."\\build\\msw");
	}
	else
	{
		die("build\\msw is Damaged\n");
		logger("PANIC:  $workpath 目录下的 build\\msw 目录不存在 \n");
	}
	# if( (-s makefile.vc) < 1024)
	# {
	# 	print -s makefile.vc;
	# 	print "\n";
	# 	die("makefile.vc is small , is likely 500k \n");
	# }
	#system("nmake /f  makefile.vc clean "); 
	system("nmake /f  makefile.vc ");
}
sub gen_wx_config_vc($)
{
	logger("生成 wx 编译配置文件 config.vc\n");
	(my $workpath)=@_;
	logger("在 $workpath 生成 build\\msw\\config.vc 文件\n");
	chdir($workpath);
	open(CONFIG, "> .\\build\\msw\\config.vc") or die("open file error, $!\n");	
	print CONFIG <<EOF
#2011_06_28_ 星期二 add by greshem
#最后的参数精简成这个样子,想了解 他们的含义看 wxwidgets 的自带的config.vc 文件.
CC = cl
CXX = cl
CFLAGS = 
CXXFLAGS = 
CPPFLAGS = 
LDFLAGS = 
CPP = \$(CC) /EP /nologo
#动态链接库.
SHARED = 0
WXUNIV = 0
#utf8 编码.
UNICODE = 1
MSLU = 0
#调试: debug | release
BUILD = release
TARGET_CPU = \$(CPU)
DEBUG_INFO = default
DEBUG_FLAG = default
DEBUG_RUNTIME_LIBS = default
MONOLITHIC = 0
USE_GUI = 1
USE_HTML = 1
USE_MEDIA = 1
USE_XRC = 1
USE_AUI = 1
USE_RICHTEXT = 1
USE_OPENGL = 0
USE_ODBC = 0
USE_QA = 1
USE_EXCEPTIONS = 1
USE_RTTI = 1
USE_THREADS = 1
USE_GDIPLUS = 0
OFFICIAL_BUILD = 0
VENDOR = custom
WX_FLAVOUR = 
WX_LIB_FLAVOUR = 
CFG = 
CPPUNIT_CFLAGS = 
CPPUNIT_LIBS = 
RUNTIME_LIBS = dynamic
EOF
;
	close(CONFIG);
	logger("配置文件生成成功\n");
}
sub copy_intall_lib($)
{
	(my $workpath)=@_;
	logger("拷贝安装静态wx lib \n");
	chdir($workpath);
	if (-d "lib\\vc_dll\\")
	{
		chdir("lib\\vc_dll\\");
	}
	else
	{
			logger( "编译之后: lib\\vc_dll\\"+" 目录不存在,取消进一步安装,请删除wxWdiegst-2.8.10文件夹后,再继续安装");
			print "编译之后: lib\\vc_dll\\"+" 目录不存在,取消进一步安装,请删除wxWdiegst-2.8.10文件夹后,再继续安装";
			exit();
	}
	if( ! -d "D:\\usr\\lib")
	{
		mkdir("D:\\usr\\lib\\");
	}
	system("copy /y *.lib D:\\usr\\lib\\");

	my $number=scalar(glob("D:\\usr\\lib\\wx*.lib"));
	logger("一共安装了 $number 个  wx的静态库\n");
	#system("copy /y *.dll D:\\usr\\lib"):
	#print "copy /y *.lib D:\\usr\\lib failed, please check"
}
sub copy_intall_dll($)
{
	logger("拷贝安装wx dll\n");
	(my $workpath)=@_;
	chdir($workpath);
	if (-d "lib\\vc_dll\\")
	{
		chdir("lib\\vc_dll\\");
	}
	else
	{
			print "编译之后: lib\\vc_dll\\"+" 目录不存在,取消进一步安装,请删除wxWdiegst-2.8.10文件夹后,再继续安装";
			exit();
	}

	system("xcopy /y /S mswud D:\\usr\\include\\mswud\\");
	system("copy /y *.dll C:\\WINDOWS\\");
	system("copy /y *.dll D:\\usr\\lib");


	my $number=scalar(glob("D:\\usr\\lib\\wx*.dll"));
	logger("一共安装了 $number 个  wx的dll\n");
}

#拷贝include目录到D:\usr\include	
sub copy_isntall_include_header($)
{
	logger("拷贝安装 头文件\n");
	(my $workpath)=@_;
	chdir($workpath);
	if (! -d "include")
	{
		logger("include 头文件不存在 错误\n");
		die("include 头文件不存在 错误\n");
	}
	system("xcopy /y /S include D:\\usr\\include\\");
}
sub extract_wxWidgets()
{
	logger("当前目录下解压 wxWidgets-2.8.10.pack 代码文件\n");
	if (-f ("wxWidgets-2.8.10.tar.gz"))
	{
		system('"C:\\Program Files\\WinRAR\\WinRar.exe" x wxWidgets-2.8.10.tar.gz C:\\');
		return 1;
	}
	if (-f ("wxWidgets-2.8.10.tar.bz2"))
	{
		system('"C:\\Program Files\\WinRAR\\WinRar.exe" x wxWidgets-2.8.10.tar.bz2 C:\\');;;;
		return 1;
	}
	if ( -f ("wxWidgets-2.8.10.zip"))
	{
		system('"C:\\Program Files\\WinRAR\\WinRar.exe" x wxWidgets-2.8.10.zip C:\\');
		return 1;
	}
	return 0;
}
#修改wxWidgets-2.8.10/include/msvc/目录下的setup.h文件
sub _modify_setup_headfile($)
{
	(my $workpath)=@_;
	chdir($workpath);

	logger("修改vc 的编译头文件,   $workpath \include\\msvc\\wx\\setup.h \n");	
	if (-f "C:\\cygwin\\bin\\sed.exe")
	{
	logger("cygwin sed.exe 存在, 开始替换 \n");
	system('C:\\cygwin\\bin\\sed.exe -e "s/\.\.\/lib\/vc_dll\///g" -i  include\\msvc\\wx\\setup.h') ;
	system('C:\\cygwin\\bin\\sed.exe -e "s/\.\.\/lib\/vc_lib\///g" -i  include\\msvc\\wx\\setup.h') ;
	chdir("d:\\");
	system('C:\\cygwin\\bin\\sed.exe -e "s/\.\.\/lib\/vc_lib\///g" -i		D:\\usr\\include\\msvc\\wx\\setup.h') ;
	system('C:\\cygwin\\bin\\sed.exe -e "s/\.\.\/lib\/vc_dll\///g" -i		D:\\usr\\include\\msvc\\wx\\setup.h') ;

	}
	else
	{
		logger("cygwin sed.exe 不存在\n");
		logger(" $workpath include//msvc/wx/setup.h 的include  ../lib/vc_dll  ../lib/vc_lib 没有替换为空");
		print (" setup.h 的include  ../lib/vc_dll  ../lib/vc_lib 替换为空");
	}
}


#日志跨平台在两个操作系统上
sub logger($)
{
	(my $log_str)=@_;
	if($^O=~/win32/i)
	{
		open(FILE, ">>  c:\\log\\install_wxwidgets.log");
	}
	else
	{
		open(FILE, ">>  /var/log/install_wxwidgets.log");
	}

		print "#".$log_str."\n";;
		print FILE $log_str;
		close(FILE);
}

sub install_in_linux()
{
	warn("#linux下wxWidgets 编译用 /bin/wxwidget_diskplat_install.pl\n");
	warn("#下面打印 步骤概要\n");
	print(" unzip wxWidgets-2.8.10.zip /root/\n");	
	print  ("cd wxWidgets-2.8.10/\n");
	print (" mkdir buildgtk\n");
	
	print("../configure --with-gtk --enable-unicode --disable-shared --prefix=/usr\n");
	print("make\n");
	print("make install\n");
	print ("cd /etc/ld.so.conf.d \n");
	print ("echo \"/usr/lib\" > /etc/ld.so.conf.d/wx.conf \n");
	print ("ldconfig \n");
	print("cp  ./buildgtk/lib/wx/include/gtk2-unicode-release-static-2.8/wx/setup.h  /usr/local/include/wx-2.8/wx/ \n ");
}
########################################################################
#mainloop
if( $^O =~/linux/i)
{
	install_in_linux();
	die("#linux 下退出\n");
}
print $path=get_wxWidgets_working_path();;
if(!defined($path))
{
	extract_wxWidgets();
}
#再获取一遍.
$path=get_wxWidgets_working_path();;
if(!defined($path))
{
	logger("#没有 wxwidgets 的源码解压目录 \n");
	die("#没有 wxwidgets 可以用目录\n");
}

my $command=shift;
if($command=~/clean|clear/)
{
		cleanup($path);
}
gen_wx_config_vc($path);
compile_with_nmake($path);

#install_to_d_disk, 安装到d盘. 
if( -d "d:\\")
{
	copy_intall_lib($path);
	copy_intall_dll($path);
	copy_isntall_include_header($path);

	_modify_setup_headfile($path);
}
