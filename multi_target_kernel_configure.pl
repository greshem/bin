#!/usr/bin/perl
for_each_kernel_arch();
#==========================================================================
#yum install gcc* #f18 i386 
sub deal_with_3_9_5()
{
print <<EOF
#=================================
make ARCH=arm CROSS_COMPILE=arm-linux-gnu-   -j8 

for each in \$(find arch/ -maxdepth 1 -mindepth 1 -type d )
do
name=\$(echo \$each |sed 's/arch\\///g' ) 
echo rm -f vmlinux
echo make ARCH=\$name CROSS_COMPILE=\$name-linux-gnu-   allnoconfig  
echo make ARCH=\$name CROSS_COMPILE=\$name-linux-gnu-   -j8 
echo cp vmlinux  vmlinux_\$name
done

EOF
;
 
}

#deal_with_3_9_5();

sub for_each_kernel_arch()
{
	my $each;
	my @tmp= grep {-d } glob("arch/*");
	if(scalar (@tmp) == 0)
	{
		die("#ERROR: curent dir is not linux kernel source code dir \n");
	}
	for $each (@tmp)
	{
		my $name=$each;
		$name=~s/arch\///g;
		open(FILE, ">build_$name.sh") or die("open build_$name error \n");
		print FILE <<EOF
rm -f vmlinux
make ARCH=$name CROSS_COMPILE=$name-linux-gnu-   allnoconfig  
make ARCH=$name CROSS_COMPILE=$name-linux-gnu-   -j8 
cp vmlinux  vmlinux_$name
EOF
;

	}
}


for_each_kernel_arch_header();
sub for_each_kernel_arch_header()
{
	my $each;
	my @tmp= grep {-d } glob("arch/*");
	if(scalar (@tmp) == 0)
	{
		die("#ERROR: curent dir is not linux kernel source code dir \n");
	}
	for $each (@tmp)
	{
		my $name=$each;
		$name=~s/arch\///g;
		open(FILE, ">header_install_$name.sh") or die("open build_$name error \n");
		print FILE <<EOF

make ARCH=$name CROSS_COMPILE=$name-linux-gnu-   headers_install   INSTALL_HDR_PATH=/opt/header_${name}/
echo Install to  /opt/${name}_header/
EOF
;

	}
}



deal_with_headers_install_multi_version();
sub deal_with_headers_install_multi_version()
{
	use Cwd;
	use File::Basename;

	our $g_pwd=getcwd();
	our $g_basename=basename($g_pwd);
	our $g_dirname=dirname($g_pwd);

	for $each (grep {-d } glob("linux-*"))
	{
		print <<EOF
		cd $g_pwd/$each;
		mkdir /opt/${each}_header
		make  headers_install  INSTALL_HDR_PATH=/opt/${each}_header/

EOF
;
	}
}
