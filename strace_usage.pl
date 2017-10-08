#!/usr/bin/perl
$type=shift;

if(!defined($type))
{
	common();
}
else
{
	common();
	all();
}

########################################################################
sub common()
{
	print <<EOF
strace -s 4096   -p 1			#��������ӡ4096	  pid
strace -s 32    -p 1 			#��������С 32		truncation

strace -f -o configure-strace.txt -e execve ./configure #���� execve ����, system

strace -e trace=open -p 1 		#open ����
strace -e trace=open mkinitrd   #׷��  mkinitrd ���� ������Щ�ļ�.
strace -e trace=file  -p 1      #�ļ�����,  file operator 
strace -e trace=process  -p 1 	#���ٽ��� 
strace -e trace=network 		#���� 
strace -e signal=!io 			#������  SIGIO�ź�.
strace -e open lspci 			#��lspci ʹ�õ�  ���ݿ��ļ�. 
strace -o /tmp/ip_link_output.log  ip link		#output file
strace -f -trace=file -p $(pidof  xinetd) 		#trace fork subprocess , bgp rlogin nopasswd
strace -e ioctl  ifconfig		#ifconfig ioctl �ĵ���. 
strace -e read=3,5  			#read �� 3 5 �˿� ��ȡ������.

EOF
;
}
sub all()
{
	print <<EOF
#2010_12_23_ add by greshem

��Ҫ���ٵ�����. 
strace  -e trace=file  -p 13479     
strace -f -o configure-strace.txt -e execve ./configure ���� execve ����. 
########################################################################
-eopen�ȼ��� -e trace=open,��ʾֻ����open����.��-etrace!=open��ʾ���ٳ���open�������������.�������ر�ķ��� all �� none.
ע����Щshellʹ��!��ִ����ʷ��¼�������,����Ҫʹ�ãܣ�.
-e trace=set
ֻ����ָ����ϵͳ����.����:-e trace=open,close,rean,write��ʾֻ�������ĸ�ϵͳ����.Ĭ�ϵ�Ϊset=all.
-e trace=file
ֻ�����й��ļ�������ϵͳ����.
-e trace=process
ֻ�����йؽ��̿��Ƶ�ϵͳ����.
-e trace=network
���ٺ������йص�����ϵͳ����.
-e strace=signal
�������к�ϵͳ�ź��йص�ϵͳ����
-e trace=ipc
�������кͽ���ͨѶ�йص�ϵͳ����
-e abbrev=set
�趨strace�����ϵͳ���õĽ����.-v �Ⱥ� abbrev=none.Ĭ��Ϊabbrev=all.
-e raw=set
��ָ����ϵͳ���õĲ�����ʮ��������ʾ.
-e signal=set
ָ�����ٵ�ϵͳ�ź�.Ĭ��Ϊall.��signal=!SIGIO(��signal=!io),��ʾ������SIGIO�ź�.
-e read=set
�����ָ���ļ��ж���������.����:
-e read=3,5
-e write=set
//########################################################################

���gdb �� ��GDB �����ȡ һ�����̵����е��̣߳� info threads ���֮�� ����ȡ
PID Ȼ�� strace -p pid Ȼ�� �Ϳ��Ը���ÿ���߳���. ����һ�����е��̣߳� ��ʱ֮�� Ȼ���ٰ� STRACE ɱ������ Ȼ�� ���Ը��ٳ���ÿ�������ض�ʱ�̵�IO�� ��Ѱ�ң� ÿ�������Ľ��̣�  
EOF
;

}

