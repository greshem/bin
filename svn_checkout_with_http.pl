#!/usr/bin/perl
#2011_02_21_18:46:02 add by greshem ����ֻ��ӱ��ص� CO ������ ֮�� �����ͨ������CO ������ �Ľ���. 

use File::Basename;
#print basename("/root/linux/bbb"); #�����. bbb
	
#�ļ���ʽ����.
#htpasswd -b  /etc/subversion/passwd wuling wuling
sub load_svn_passwd()
{
	my %passwd_hash;
	my $passwd_file= "/root/svn_server_dav_httpd/batch_add_users/batch_add_user.sh";
	if( ! -f  $passwd_file)	
	{
		die("û��svn �����ļ� �˳�\n");
	}
	open(FILE, $passwd_file) or die("open file error\n");
	for(<FILE>)
	{
		if($_=~/\/etc\/subversion\/passwd\s+(\S+)\s+(\S+)/ )
		{
			my $username=$1;
			my $passwd=$2;
			$passwd_hash{$username}=$passwd;	
		}
	}
	close(FILE);
	return %passwd_hash;
}

sub get_ip()
{
	open(PIPE, "ifconfig |") or die("open ifconfig cmd failuer\n");
	for(<PIPE>)
	{
		if($_=~/192.168.0.234/)
		{
			return "acer";
		}
		if($_=~/192.168.1.73/)
		{
			return "acer";
		}
	}
	return "acer";
}
########################################################################
#mainloop 
our $g_ip=get_ip();
our %g_hash= load_svn_passwd();
our $g_repo;

my $input=shift;

our $g_username=shift;
if(!defined($input))
{
	$g_repo="svn";;
}
else
{
	$g_repo=$input;
}
print_from_one_repo($g_repo);

sub print_from_one_repo($)
{
	(my $repo)=@_;
	if(! defined($repo))
	{
		$repo="svn";
	}
	if(! -d "/home/$repo")
	{
		die("/home/$repo ������\n");
	}
	for (glob("/home/$repo/*") )
	{
		if( -d $_)
		{
			$url=$_;
			$url=~s/^\/home//g;
			#print "svn co http://192.168.0.234/".$url."\t". basename($_)." \n";
			if(defined($g_username))
			{
				print "svn  --username $g_username  --password $g_hash{$g_username}   co http://".$g_ip."\/".$url."/ \t". basename($_)." \n";
			}
			else
			{
				print "svn co http://".$g_ip."\/".$url."/ \t". basename($_)." \n";
			}
		}
	}
}
