#!/usr/bin/perl
#2012_03_13_17:33:07   ���ڶ�   add by greshem

rmmod_kernel_bridge();
install_ovs_kernel_mod();

create_ovs_db();
start_ovs_srv();
add_ovs_bridge();

########################################################################
#����bgp �Ļ��� �����.
sub add_ovs_bridge()
{
	#��ɾ�����ݿ�, ��sqlite �д��л���.
	system_exec_must_success_or_die("ovs-vsctl del-port br100 em3 ");	
	system_exec_must_success_or_die("ovs-vsctl del-br br100  ");	


	system_exec_must_success_or_die("ovs-vsctl add-br br100	");		#��� br100����.
	system("ifconfig br100");
	system("ifconfig br100 up");
	system("ifconfig em3 up");
		
	system_exec_must_success_or_die("ovs-vsctl add-port br100 em3 ");	
}


#==========================================================================
#��װ openvswitch���ں�ģ��.
sub install_ovs_kernel_mod()
{
	if( ! -d  "/root/openvswitch-1.0.1/")
	{
		my_die(" openvswitch-1.0.1 Դ��Ŀ¼������, �ϴ�������. \n");
	}
	else
	{
		my $ret_str=`lsmod |grep openvswitch_mod` ;
		if($? >> 8 eq 0)
		{
			logger("openvswitch_mod �Ѿ���װ, ����\n");
					}
		else
		{
			install_mod_ovs();
			install_mod_br();
		}
	}
}

#==========================================================================
#���� ovs �ķ���.
sub start_ovs_srv()
{
	system("pkill ovsdb-server");
	system("pkill ovs-vsw");
	system_exec_must_success_or_die("ovsdb-server /etc/ovs-vswitchd.conf.db  --remote=punix:/var/run/openvswitch/db.sock --detach ");
	system_exec_must_success_or_die("ovs-vswitchd unix:/var/run/openvswitch/db.sock --pidfile --detach ");
}

#==========================================================================
#���� ovs �ڲ������ݿ�.
sub create_ovs_db()
{
	if( ! -f  "/etc/ovs-vswitchd.conf.db")
	{
		logger(" /etc/ovs-vswitchd.conf.db  ������, ����\n");
		system_exec_must_success_or_die("ovsdb-tool create /etc/ovs-vswitchd.conf.db  /root/openvswitch-1.0.1/vswitchd/vswitch.ovsschema");
	}
	else
	{
		logger(" ovs �����ݿ� ���� , ���ô���\n");
	}
}
#==========================================================================
#��װ ovs ģ��
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
#��װ��ģ��.
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
#�Ƴ��Դ����ں� bridge.ko ģ��.
sub rmmod_kernel_bridge()
{
	my $ret_str=`lsmod |grep bridge` ;
	if($? >> 8 eq 0)
	{
		logger (" bridge.ko ģ�����, ɾ��ģ�� \n");
		system("rmmod bridge");
	}
	else
	{
		logger ("bridget.ko ģ�� �Ѿ�ɾ�� \n");
	}
}

#==========================================================================
#����ִ�гɹ����� ʧ���˳�
sub system_exec_must_success_or_die($)
{
	(my $cmd_str)=@_;
	logger("ִ������: $cmd_str\n");
	system($cmd_str);
	if($?>>8 ne 0)
	{
		my_die("������: $cmd_str ִ��ʧ��\n");
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

