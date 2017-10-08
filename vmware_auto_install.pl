#!/usr/bin/perl
if($^O=~/win/i)
{
	print <<EOF
#windows  rhel 的安装  都可以通过下面的程序 来 实现 自动安装. 
D:\\svn_working_path\\develop_qemu_kvm_100\\vmware_auto_install\\gen_vmware_auto_install_vmx.pl 
EOF
;

}
