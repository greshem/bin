#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
bakefile build.bkl -f msvc -o makefile.vc -DWX_DEBUG=1 -DWX_SHARED=1 -DBUILD=debug -DBUILDDIR=Debug  -IC:\works\wxWidgets-2.8.10\build\bakefiles\wxpresets -DWX_DIR=C:\works\wxWidgets-2.8.10 -DWX_UNICODE=1


bakefile build.bkl -f msvc6prj -o makefile.vc -DWX_DEBUG=1 -DWX_SHARED=1 -DBUILD=debug -DBUILDDIR=Debug  -IC:\works\wxWidgets-2.8.10\build\bakefiles\wxpresets -DWX_DIR=C:\works\wxWidgets-2.8.10 -DWX_UNICODE=1


