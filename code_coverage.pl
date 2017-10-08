#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
"gcc  -ftest-coverage -fprofile-arcs ";
"g++  -ftest-coverage -fprofile-arcs ";

#对于 静态库  也需要    -ftest-coverage -fprofile-arcs 

# -lgcov  对于测试代码可能需要这个. 

#清空计数器
#lcov --directory . --zerocounters


#递归当前目录下的所有的   gcdo gcno
lcov --directory . --capture --output-file app.info
genhtml -o results app.info

