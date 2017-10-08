#!/usr/bin/perl
#2012_03_13_17:33:07   星期二   add by greshem

rmmod_kernel_bridge();
install_ovs_kernel_mod();

create_ovs_db();
start_ovs_srv();
add_ovs_bridge();

########################################################################
#根据bgp 的环境 添加桥.
sub add_ovs_bridge()
{
	#先删除数据库, 在sqlite 中存有缓冲.
	system_exec_must_success_or_die("ovs-vsctl del-port br100 em3 ");	
	system_exec_must_success_or_die("ovs-vsctl del-br br100  ");	


	system_exec_must_success_or_die("ovs-vsctl add-br br100	");		#添加 br100的桥.
	system("ifconfig br100");
	system("ifconfig br100 up");
	system("ifconfig em3 up");
		
	system_exec_must_success_or_die("ovs-vsctl add-port br100 em3 ");	
}


#==========================================================================
#安装 openvswitch的内核模块.
sub install_ovs_kernel_mod()
{
	if( ! -d  "/root/openvswitch-1.0.1/")
	{
		my_die(" openvswitch-1.0.1 源码目录不存在, 上传并编译. \n");
	}
	else
	{
		my $ret_str=`lsmod |grep openvswitch_mod` ;
		if($? >> 8 eq 0)
		{
			logger("openvswitch_mod 已经安装, 跳过\n");
					}
		else
		{
			install_mod_ovs();
			install_mod_br();
		}
	}
}

#==========================================================================
#启动 ovs 的服务.
sub start_ovs_srv()
{
	system("pkill ovsdb-server");
	system("pkill ovs-vsw");
	system_exec_must_success_or_die("ovsdb-server /etc/ovs-vswitchd.conf.db  --remote=punix:/var/run/openvswitch/db.sock --detach ");
	system_exec_must_success_or_die("ovs-vswitchd unix:/var/run/openvswitch/db.sock --pidfile --detach ");
}

#==========================================================================
#创建 ovs 内部的数据库.
sub create_ovs_db()
{
	if( ! -f  "/etc/ovs-vswitchd.conf.db")
	{
		logger(" /etc/ovs-vswitchd.conf.db  不存在, 创建\n");
		system_exec_must_success_or_die("ovsdb-tool create /etc/ovs-vswitchd.conf.db  /root/openvswitch-1.0.1/vswitchd/vswitch.ovsschema");
	}
	else
	{
		logger(" ovs 的数据库 存在 , 不用创建\n");
	}
}
#==========================================================================
#安装 ovs 模块
sub install_mod_ovs()
{
	$mod_ovs= "/root/openvswitch-1.0.1/datapath/linux-2.6/openvswitch_mod.ko";
	if( -f   $mod_ovs)
	{
		system_exec_must_success_or_die("insmod  $mod_ovs");
	}
	else
	{
		die ("Error: $mod_ovs not exists\n");
	}
}

#==========================================================================
#安装桥模块.
sub install_mod_br()
{

	$mod_br="/root/openvswitch-1.0.1/datapath/linux-2.6/brcompat_mod.ko";
	if( -f $mod_br)
	{
		system_exec_must_success_or_die("insmod $mod_br");
	}
	else
	{	
		die ("Error: $mod_br not exists\n");
	}
}


#==========================================================================
#移除自带的内核 bridge.ko 模块.
sub rmmod_kernel_bridge()
{
	my $ret_str=`lsmod |grep bridge` ;
	if($? >> 8 eq 0)
	{
		logger (" bridge.ko 模块存在, 删除模块 \n");
		system("rmmod bridge");
	}
	else
	{
		logger ("bridget.ko 模块 已经删除 \n");
	}
}

#==========================================================================
#必须执行成功否则 失败退出
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

#==========================================================================
sub logger($)
{
	(my $log_str)=@_;
	open(FILE, ">> /tmp/start_ovs.log") or warn("open /tmp/start_ovs.log error\n");
	print FILE $log_str;
	close(FILE);
}

sub my_die($)
{
	(my $log_str)=@_;
	open(FILE, ">> /tmp/start_ovs.log") or warn("open /tmp/start_ovs.log error\n");
	print FILE $log_str;
	close(FILE);
	die($log_str);
}

