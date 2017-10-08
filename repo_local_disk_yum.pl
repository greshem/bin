#!/usr/bin/perl
#2011_03_03_14:10:40   ÐÇÆÚËÄ   add by greshem
use strict;
use File::Basename;
print get_GPG_key_file("/tmp/dir/");


my $input;
$input=shift  or die("Usage: input_dir_or_http_string     saved_name   \n");
my $name=shift   or die("Usage: input_dir_or_http_string     saved_name   \n");
if( -d $input)
{
    $input=check_local_repo($input);
}
gen_repo_file($input,$name);
system("sed 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.conf -i ");

 
########################################################################
sub gen_http_repo($$)
{
    (my $dir, $name)=@_;
    gen_repo_file($dir,$name);
    system("sed 's/gpgcheck=1/gpgcheck=0/g' /etc/yum.conf -i ");
}

sub check_local_repo($)
{
    (my $dir)=@_;

    if(! -d  $dir)
    {
        die("ERROR: $dir is not dir \n");
    }

    if($dir !~ /^\//)
    {
        die("$dir is not absulute path\n");
    }
    elsif ( ! -d $dir."/repodata")
    {
        die(" $dir is not repo \n");
    }
    else
    {
        $dir=$dir."/";
    }
    return $dir;
}

if( grep(/force/i, @ARGV))
{
	gen_repo_file("template");
}



########################################################################
#subfunc
sub get_GPG_key_file($)
{
	(my $dir)=@_;
    if( ! -d $dir)
    {
        warn("$dir is not dir, skip \n");
        return; 
    }

	$dir=dirname($dir);
	my @keys=`find $dir|grep KEY`;
	#print join("\n", @keys);
	my @release_keys=grep {/release/i} @keys;
	if(scalar(@release_keys) ==0 )
	{
		warn("GPG release is  null, die \n");
	}
	return $release_keys[0];
}


sub gen_repo_file($)
{

	(my $dir, my $name)=@_;
	#my $reponame=basename($dir);
	my $reponame=$name;
    my $baseurl;

    if(-d $dir)
    {
        $baseurl="file://$dir";
    }
    elsif($dir=~/^http/)
    {
        $baseurl="$dir";
    }

	my $gpg_key_file= get_GPG_key_file($dir);
	open(FILE, ">/etc/yum.repos.d/".$reponame.".repo") or die("open file error $!\n");
	print  FILE <<EOF
[$reponame]
name=$reponame
baseurl=$baseurl
#baseurl=http://pms.syscloud.cn/mirrors/centos/7.0.1406/os/x86_64/
#baseurl=ftp://pms.syscloud.cn/mirrors/centos/7.0.1406/os/x86_64/

enabled=1
gpgcheck=0
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5
gpgkey=file://$gpg_key_file
EOF
;

	if ( -f "/etc/yum.repos.d/".$reponame.".repo" )
	{
		print  "OK: /etc/yum.repos.d/".$reponame.".repo  file create\n";
	}
	else
	{
		print  "ERROR: /etc/yum.repos.d/".$reponame.".repo  file not created\n";
	}
}
