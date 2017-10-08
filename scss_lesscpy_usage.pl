#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#lesscpy, 网址 
cd /home/git_linux_src/
git clone https://github.com/robotis/Lesscpy/


cd /home/git_linux_src/Lesscpy/test/less
lesscpy    colors.less   > /tmp/a.css

