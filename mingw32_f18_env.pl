#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
mingw32-binutils
mingw32-cpp
mingw32-gcc
mingw32-gcc-c++

#mingw 最小 工具包
mingw32-runtime  (mingw32-crt)
mingw32-w32api
mingw32-filesystem

