#!/usr/bin/perl
do("c:\\bin\\sed.pl");
our $vim_plugin_path='C:\\Program Files\\Vim\\vim72\\plugin\\';
#our $vim_plugin_path2='C:\Program Files\Vim\vim72\plugin\';

if( ! -d $vim_plugin_path )
{
	logger("vim 没有安装 请安装vim \n");
	die("vim 没有安装 请安装vim \n");
}
install_from_svn_path("e:\\svn_working_path\\vim_common\\win32_plugin");
install_from_svn_path("d:\\svn_working_path\\vim_common\\win32_plugin");
set_nobackup();



########################################################################
#vim 的文件编辑的文件不要备份.
sub set_nobackup()
{
	$sed_path= "c:\\cygwin\\bin\\sed.exe";
	$vim_conf="C:\\Program Files\\Vim\\vim72\\vimrc_example.vim";
	if( ! -f $vim_conf)
	{
		logger(" $vim_conf 配置文件不存在\n");
		return ;
	}

	if( ! -f $sed_path)
	{
		logger(" $sed_path 不存在,使用 自己实现的perl 的c:\\bin\\sed.pl 程序 \n");
		sed_file($vim_conf, "set backup","set nobackup");
		rename($vim_conf.".sed_output", $vim_conf);
	}
	else
	{
		logger("实用cygwin 的sed.exe \n");
		chdir("c:\\");
		logger(" \"$sed_path\" -i \"s/set backup/set nobackup/g\" \"$vim_conf\" ");
		system(" \"$sed_path\" -i \"s/set backup/set nobackup/g\" \"$vim_conf\" ");
	}
	
}
sub install_from_svn_path()
{
	(my $path)=@_;
	if(! -d $path)
	{
		logger(" vim 的插件目录: $path 目录不存在\n");
		return ;
	}

	foreach (glob($path."\\*"))
	{
		if( -f $_)
		{
			print ("copy /y $_ \"$vim_plugin_path\"\n");	
			system("copy /y $_ \"$vim_plugin_path\"\n");	
		}
	}
}


sub logger($)
{
	if( ! -d "d:\\log")
	{
		mkdir("d:\\log");
	}
	(my $log_str)=@_;
	open(FILE, ">> d:\\log\\vim_plug_install.log");
	print FILE $log_str;
	close(FILE);
}
