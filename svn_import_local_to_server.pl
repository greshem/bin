#!/usr/bin/perl
use Cwd;
$pwd=getcwd();
print "\#当前目录: $pwd \n";


use File::Basename;
#print basename("/root/linux/bbb"); #结果是. bbb

our $targetname=basename($pwd);


	print <<EOF
	mkdir trunk
	mkdir branches  
	mkdir tags  

	mkdir /home/svn/$targetname
	cd  /home/svn/$targetname
	svnadmin create \$(pwd)
	svn  import $pwd  file:///home/svn/$targetname -m "import a new"
	chmod 777 -R /home/svn/$targetname
	cd $pwd
	svn co http://acer//svn/$targetname    ~/$targetname 
EOF
;


print "\#	/home/svn/access-control 添加对应的项目. \n";
print "\#  不要忘记,  /root/svn_server_dav_httpd/batch_add_users/ 用户的密码\n";

if( shell_grep($targetname, "/home/svn/access-control") )
{
	print "#权限控制已经存在了 不需要再添加权限控制了\n";
	die("\n");
}
else
{
	append_to_access_control();
}
########################################################################
sub append_to_access_control()
{
	open(FILE, ">> /home/svn/access-control")  or die(" open file error\n");
	print FILE <<EOF	
[$targetname:/]
root=rw
greshem=rw
wenshuna=rw
huanghaibo=rw
gengerbin=rw

EOF
;
	close(FILE);
}

########################################################################
sub shell_grep($$)
{
	(my $pattern, $file)=@_;
	open(FILE, $file) or die("Open file $file error\n");
	my $count=undef;
	for(<FILE>)
	{
		if($_=~/$pattern/)
		{
			$count++;
		}
	}
	return $count;
}

