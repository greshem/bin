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
		logger("PANIC:  $workpath Ŀ¼�µ� build\\msw Ŀ¼������ \n");
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
	logger("���� wx ���������ļ� config.vc\n");
	(my $workpath)=@_;
	logger("�� $workpath ���� build\\msw\\config.vc �ļ�\n");
	chdir($workpath);
	open(CONFIG, "> .\\build\\msw\\config.vc") or die("open file error, $!\n");	
	print CONFIG <<EOF
#2011_06_28_ ���ڶ� add by greshem
#���Ĳ���������������,���˽� ���ǵĺ��忴 wxwidgets ���Դ���config.vc �ļ�.
CC = cl
CXX = cl
CFLAGS = 
CXXFLAGS = 
CPPFLAGS = 
LDFLAGS = 
CPP = \$(CC) /EP /nologo
#��̬���ӿ�.
SHARED = 0
WXUNIV = 0
#utf8 ����.
UNICODE = 1
MSLU = 0
#����: debug | release
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
	logger("�����ļ����ɳɹ�\n");
}
sub copy_intall_lib($)
{
	(my $workpath)=@_;
	logger("������װ��̬wx lib \n");
	chdir($workpath);
	if (-d "lib\\vc_dll\\")
	{
		chdir("lib\\vc_dll\\");
	}
	else
	{
			logger( "����֮��: lib\\vc_dll\\"+" Ŀ¼������,ȡ����һ����װ,��ɾ��wxWdiegst-2.8.10�ļ��к�,�ټ�����װ");
			print "����֮��: lib\\vc_dll\\"+" Ŀ¼������,ȡ����һ����װ,��ɾ��wxWdiegst-2.8.10�ļ��к�,�ټ�����װ";
			exit();
	}
	if( ! -d "D:\\usr\\lib")
	{
		mkdir("D:\\usr\\lib\\");
	}
	system("copy /y *.lib D:\\usr\\lib\\");

	my $number=scalar(glob("D:\\usr\\lib\\wx*.lib"));
	logger("һ����װ�� $number ��  wx�ľ�̬��\n");
	#system("copy /y *.dll D:\\usr\\lib"):
	#print "copy /y *.lib D:\\usr\\lib failed, please check"
}
sub copy_intall_dll($)
{
	logger("������װwx dll\n");
	(my $workpath)=@_;
	chdir($workpath);
	if (-d "lib\\vc_dll\\")
	{
		chdir("lib\\vc_dll\\");
	}
	else
	{
			print "����֮��: lib\\vc_dll\\"+" Ŀ¼������,ȡ����һ����װ,��ɾ��wxWdiegst-2.8.10�ļ��к�,�ټ�����װ";
			exit();
	}

	system("xcopy /y /S mswud D:\\usr\\include\\mswud\\");
	system("copy /y *.dll C:\\WINDOWS\\");
	system("copy /y *.dll D:\\usr\\lib");


	my $number=scalar(glob("D:\\usr\\lib\\wx*.dll"));
	logger("һ����װ�� $number ��  wx��dll\n");
}

#����includeĿ¼��D:\usr\include	
sub copy_isntall_include_header($)
{
	logger("������װ ͷ�ļ�\n");
	(my $workpath)=@_;
	chdir($workpath);
	if (! -d "include")
	{
		logger("include ͷ�ļ������� ����\n");
		die("include ͷ�ļ������� ����\n");
	}
	system("xcopy /y /S include D:\\usr\\include\\");
}
sub extract_wxWidgets()
{
	logger("��ǰĿ¼�½�ѹ wxWidgets-2.8.10.pack �����ļ�\n");
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
#�޸�wxWidgets-2.8.10/include/msvc/Ŀ¼�µ�setup.h�ļ�
sub _modify_setup_headfile($)
{
	(my $workpath)=@_;
	chdir($workpath);

	logger("�޸�vc �ı���ͷ�ļ�,   $workpath \include\\msvc\\wx\\setup.h \n");	
	if (-f "C:\\cygwin\\bin\\sed.exe")
	{
	logger("cygwin sed.exe ����, ��ʼ�滻 \n");
	system('C:\\cygwin\\bin\\sed.exe -e "s/\.\.\/lib\/vc_dll\///g" -i  include\\msvc\\wx\\setup.h') ;
	system('C:\\cygwin\\bin\\sed.exe -e "s/\.\.\/lib\/vc_lib\///g" -i  include\\msvc\\wx\\setup.h') ;
	chdir("d:\\");
	system('C:\\cygwin\\bin\\sed.exe -e "s/\.\.\/lib\/vc_lib\///g" -i		D:\\usr\\include\\msvc\\wx\\setup.h') ;
	system('C:\\cygwin\\bin\\sed.exe -e "s/\.\.\/lib\/vc_dll\///g" -i		D:\\usr\\include\\msvc\\wx\\setup.h') ;

	}
	else
	{
		logger("cygwin sed.exe ������\n");
		logger(" $workpath include//msvc/wx/setup.h ��include  ../lib/vc_dll  ../lib/vc_lib û���滻Ϊ��");
		print (" setup.h ��include  ../lib/vc_dll  ../lib/vc_lib �滻Ϊ��");
	}
}


#��־��ƽ̨����������ϵͳ��
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
	warn("#linux��wxWidgets ������ /bin/wxwidget_diskplat_install.pl\n");
	warn("#�����ӡ �����Ҫ\n");
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
	die("#linux ���˳�\n");
}
print $path=get_wxWidgets_working_path();;
if(!defined($path))
{
	extract_wxWidgets();
}
#�ٻ�ȡһ��.
$path=get_wxWidgets_working_path();;
if(!defined($path))
{
	logger("#û�� wxwidgets ��Դ���ѹĿ¼ \n");
	die("#û�� wxwidgets ������Ŀ¼\n");
}

my $command=shift;
if($command=~/clean|clear/)
{
		cleanup($path);
}
gen_wx_config_vc($path);
compile_with_nmake($path);

#install_to_d_disk, ��װ��d��. 
if( -d "d:\\")
{
	copy_intall_lib($path);
	copy_intall_dll($path);
	copy_isntall_include_header($path);

	_modify_setup_headfile($path);
}
