#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#!/bin/bash -e

autoheader
automake --add-missing
autoreconf
./configure
make clean
make
make check


#有时候仅仅需要这一句.
#/mnt/sda3/xhzhou/tmp/qserver
autoreconf

#==========================================================================
#!/bin/sh
aclocal -I m4
autoheader
autoconf
libtoolize --force
automake --add-missing


#==========================================================================
