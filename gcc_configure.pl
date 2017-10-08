#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
./contrib/download_prerequisites
../configure --enable-checking=release --enable-languages=c,c++ --disable-multilib --prefix=/opt/gcc_4.8.1
../gcc-4.8.1/configure --enable-checking=release --enable-languages=c,c++ --disable-multilib



