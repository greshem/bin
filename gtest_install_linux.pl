#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#for gtest 1.6.0 
#g++ -I${GTEST_DIR}/include -I${GTEST_DIR} -c ${GTEST_DIR}/src/gtest-all.cc
#ar -rv libgtest.a gtest-all.o

svn co http://acer/svn/system_initialization_win/ /tmp/system_init_win

 cp   /tmp/systek_init_win/gtest-1.6.0.zip  /tmp/
cd /tmp/
unzip /tmp/gtest-1.6.0.zip 
cd /tmp/gtest-1.6.0/
./configure
make 
cp -a -r include/gtest/ /usr/include/
ar -rv /usr/lib/libgtest.a  src/gtest-all.o




