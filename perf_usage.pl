#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
1.
 <<ǳ̸��Linux ϵͳ���ں��Լ����� perf ����>>
perf record -e /bin/ls 
perf record    --event cpu-clock -f  /bin/ls  #ʱ������
perf report

#ls  ���˶��ٴ�ϵͳ����? �����﷢����?
perf stat  -e syscalls:sys_enter ls 		#ͳ�� sys_enter ��ʹ��.

perf record -e syscalls:sys_enter ls 		#ͳ��ϵͳ���� �̺����.
perf report 

perf record   -e syscalls:sys_enter find / > /dev/null  #ͳ�� find /��ϵͳ����
perf report  						#֮����Կ��� 100% ��������4��, Ŀ¼��ص�ϵͳ����.


perf kmem -alloc ��l 10 -caller stat  # 




