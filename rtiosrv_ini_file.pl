#!/usr/bin/perl
sub create_disk_ini()
{
	if( -f "disk.ini")
	{
		logger("disk.ini 存在, 不再创建\n");
		return ;
	}
	else
	{
		logger("disk.ini 不存在, 开始创建\n");
	}
	
	open(DISK_INI, "> disk.ini") or die("create disk.ini failuer\n");
	print DISK_INI <<EOF
[SYS]
DiskSize=8
DiskFile=D:\\Rich\\Disk\\sys.IMG
CacheFile=
CacheSize=
CacheIdxFile=
EOF
;
	close(DISK_INI);
}

sub create_server_ini()
{
	if( -f "server.ini")
	{
		logger("server.ini 存在, 不再创建\n");
		return ;
	}
	else
	{
		logger("server.ini 不存在, 开始创建\n");
	}


	open(SERVER_INI, "> server.ini") or die(" create server.ini failuer \n");
	print SERVER_INI <<EOF
[192.168.7.95]
ServerIp=192.168.7.95

[192.168.1.73]
ServerIp=192.168.1.73
EOF
;
	close(SERVER_INI);
}

sub create_wks_ini()
{
	if( -f "wks.ini")
	{
		logger("wks.ini 存在, 不再创建\n");
		return ;
	}
	else
	{
		logger("wks.ini 不存在, 开始创建\n");
	}


	open(WKS_INI, "> wks.ini") or die("open  wks.ini failuer\n");
	print WKS_INI <<EOF
[000C29C460A6]
WksGroup=
Enable=1
WksName=WKS001
IpAddr=192.168.2.137
Netmask=255.255.0.0
GateWay=
BootCard=
BootDisk=SYS*0
BootServer=
WksPath=D:\Rich\wks\
ClientCache=0
HotBackup=0

[000C29B9801B]
WksGroup=
Enable=1
WksName=WKS002
IpAddr=192.168.7.11
Netmask=255.255.0.0
GateWay=
BootCard=
BootDisk=SYS*0
BootServer=
WksPath=D:\Rich\wks\
ClientCache=0
HotBackup=0

[000C29898C1B]
WksGroup=
Enable=1
WksName=WKS003
IpAddr=192.168.7.12
Netmask=255.255.0.0
GateWay=
BootCard=
BootDisk=SYS*0
BootServer=
WksPath=D:\Rich\wks\
ClientCache=0
HotBackup=0

[000C2960518E]
WksGroup=
Enable=1
WksName=WKS004
IpAddr=192.168.7.13
Netmask=255.255.0.0
GateWay=
BootCard=
BootDisk=SYS*0
BootServer=
WksPath=D:\Rich\wks\
ClientCache=0
HotBackup=0

[000C297DC386]
WksGroup=
Enable=1
WksName=WKS005
IpAddr=192.168.7.14
Netmask=255.255.0.0
GateWay=
BootCard=
BootDisk=SYS*0
BootServer=
WksPath=D:\Rich\wks\
ClientCache=128
HotBackup=0

EOF
;
}

sub create_option_ini()
{
	if( -f "option.ini")
	{
		logger("option.ini 存在, 不再创建\n");
		return ;
	}
	else
	{
		logger("option.ini 不存在, 开始创建\n");
	}


	open(OPTION_INI, "> option.ini") or die("create option.ini failuer\n");
	print OPTION_INI <<EOF
[SuperUser]
UserName=Admin
Password=

[AutoWks]
AddType=2
PreName=WKS
NameCode=3
Template=

[AllocIP]
DynamicIP=0
IpList=192.168.7.95
StartIP=192.168.7.11
StopIP=192.168.7.254

[Other]
LogError=0
ManPass=F014936A8B8900F8F014936A8B8900F8888E4B176E93CD9D888E4B176E93CD9D
SuperPass=
ClientPass=F014936A8B8900F8F014936A8B8900F8888E4B176E93CD9D888E4B176E93CD9D
AutoAddRecov=0

[DefaultPath]
RecovPath=
LogPath=

[ServerSync]
Enable=0
IsMaster=1

[SSDCache]
Enable=0
MemoryCache=1

EOF
;
	close(OPTION_INI);
}

sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> all.log") or warn("open all.log error\n");
	print FILE $log_str;
	close(FILE);
}

sub check_file()
{
	if ( ! -f "disk.ini") 
	{
		logger("disk.ini 没有生成\n");
	}

	if ( ! -f "server.ini") 
	{
		logger("server.ini 没有生成\n");
	}

	if ( ! -f "option.ini") 
	{
		logger("option.ini 没有生成\n");
	}

	if ( ! -f "wks.ini") 
	{
		logger("wks.ini 没有生成\n");
	}
}
########################################################################
#mainloop
create_disk_ini();
create_server_ini();
create_wks_ini();
create_option_ini();

check_file();
