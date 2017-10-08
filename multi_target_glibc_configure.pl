#!/usr/bin/perl

my @tmp=grep {-d } glob("/opt/header_*/");

if(scalar(@tmp) == 0)
{
	die("#please run /bin/multi_target_kernel_configure.pl, and then run this program  \n");
}

for $each ( @tmp )
{
	print "#".$each."\n";

	use Cwd;
	use File::Basename;

	our $g_pwd=getcwd();
	our $linux_version=basename($each);
	$linux_version=~s/header_//g;
	our $g_dirname=dirname($g_pwd);



	open(FILE, ">build_${linux_version}.sh") or die("open file   error xxx build_$linux_version\n");
	print FILE  <<EOF 
	mkdir $g_pwd/build_$linux_version
	cd    $g_pwd/build_$linux_version
	../configure  --prefix=/opt/glibc_$linux_version  --host=x86_64-gnu-linux   --with-headers=$each/include/ --without-selinux  
	make -j 8  >/dev/null 
	make install 
EOF
;
	close(FILE);

}
