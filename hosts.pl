#!/usr/bin/perl 
# 同步 /etc/hosts 和 /bin/hosts.pl 里面的 域名信息 并一起保存到 /bin/hosts.pl 算法是合并算法, 最大的保存所有的信息.
# 文件的规则 可以好好看一下  用命令  "/etc/hosts"
#mainloop
my %hash_bin_hosts = read_from_bin_hosts_pl();
my %hash_etc_hosts = read_from_etc_hosts();
use Hash::Diff qw( diff );

#==========================================================================
my %diff = %{ diff( \%hash_bin_hosts, \%hash_etc_hosts ) };

my $bin_output_str="\n";;
my $etc_output_str="\n";;
for $each (keys %diff)
{
	if(! $hash_bin_hosts{$each})
	{
		#print $each."=>". $diff{$each} ."\n";
		$bin_output_str.= $each."\t". $diff{$each} ."\n";
	}
	
	if(!$hash_etc_hosts{$each})
	{
		$etc_output_str.= $each."\t". $diff{$each} ."\n";
	}
}
#==========================================================================

append_file_str("/bin/hosts.pl", $bin_output_str);
append_file_str("/etc/hosts", $etc_output_str);

#write_to_bin_hosts(%diff);
#write_to_etc_hosts(%diff);
########################################################################
#从/bin/hosts.pl 中读取.
sub read_from_bin_hosts_pl()
{
	my %ip_2_name;
	open(FILE, "/bin/hosts.pl") or die("open /bin/hosts.pl error $!\n");
	my $start=undef;
	foreach (<FILE>)
	{
		if($_ =~ /^__DATA_/)
		{
			$start=1; #开始处理__DATA__的数据段了.
		}
		
		if($start)
		{
			(my @array) = split(/\s+/,$_);
			#$ip_2_name{$array[0]}=join("\t", $array[1..$#array]);
			if(defined($array[1]))
			{
				$ip_2_name{$array[0]}=$array[1];
			}
		}		
	}
	close(FILE);
	return %ip_2_name;
}


#从 etc_hosts 中读取.
sub read_from_etc_hosts()
{
	my %ip_2_name;
	open(FILE, "/etc/hosts")  or die("Open readding hosts file error\n");
	foreach(<FILE>)
    {
			(my @array) = split(/\s+/,$_);
			#$ip_2_name{$array[0]}=join("\t", $array[1..$#array]);
			if(defined($array[1]))
			{
				$ip_2_name{$array[0]}=$array[1];
			}
    }
	return %ip_2_name;
}

sub append_file_str($$)
{
	(my $file, $str)=@_;
	open(OUTPUT, ">>".$file) or die("open file error $file\n");
	print OUTPUT $str;
	close(OUTPUT);
}

__DATA__
192.168.1.74 f13
192.168.1.74 as5
172.16.8.114 vm_as4
172.16.8.200 ding
127.0.0.1 localhost
192.168.7.95 cheng
::1 localhost6.localdomain6
172.16.8.241 tdx
172.16.8.60 vm_f8
123.58.173.106 mirrors.163.com
88.191.77.171 www.thehackademy.net
192.168.1.73  greshem
192.168.1.74 f8
127.0.0.1 localhost.localdomain
172.16.8.5 vm_as5
192.168.20.10 old
::1 localhost6
172.16.8.101 vm_server
58.215.76.156 www.cn-dos.net
172.16.8.113 vm_f13
172.16.8.6 vm_as6
172.16.8.224 qianlong
123.129.214.98 mirrors.sohu.com
172.16.8.101 vm_srv
172.16.8.55 as4
82.94.164.168 pypi.python.org
192.168.1.32 dot
172.16.8.27 debian
1.1.1.1  debian22



172.30.52.10	as5
172.16.10.40	lvm
172.16.1.151	hmc
172.30.51.10	bgp
172.30.2.71	nim
192.168.0.232	rtiosrv
220.165.12.10	mirrors.sohu.com
172.30.52.11	as6
172.16.10.98	suse
172.30.51.100	bgp_srv
#172.16.10.103	rtiosrv
172.30.2.70	aix_dev
172.16.1.251	svn.cntnsoft.int
172.30.2.60	vio
#192.168.1.13	rtiosrv
172.16.10.243	acer
216.34.181.97	www.vim.org

61.153.202.157	www.vckbase.com
219.136.242.37	www.oschina.net
