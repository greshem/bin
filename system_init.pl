#!/usr/bin/perl
if($^O =~/linux/i)
{
print <<EOF
tar -czf system_init_linux_v2.tar.gz system_init_linux_v2
tar -czf bin.tar.gz bin
tar -czf trunk.tar.gz trunk
tar -czf vim_common.tar.gz vim_common
tar -czf develop_vim.tar.gz develop_vim
tar -czf f13_i386_rpm_download.tar.gz  f13_i386_rpm_download
EOF
;
}
else
{
	print <<EOF
	find.exe adjuest  
	vc..
EOF
;
}
