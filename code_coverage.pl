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

#���� ��̬��  Ҳ��Ҫ    -ftest-coverage -fprofile-arcs 

# -lgcov  ���ڲ��Դ��������Ҫ���. 

#��ռ�����
#lcov --directory . --zerocounters


#�ݹ鵱ǰĿ¼�µ����е�   gcdo gcno
lcov --directory . --capture --output-file app.info
genhtml -o results app.info

