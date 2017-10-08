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
strace -s 4096   -p 1			#缓冲区打印4096	  pid
strace -s 32    -p 1 			#缓冲区大小 32		truncation

strace -f -o configure-strace.txt -e execve ./configure #跟踪 execve 命令, system

strace -e trace=open -p 1 		#open 函数
strace -e trace=open mkinitrd   #追踪  mkinitrd 究竟 打开了那些文件.
strace -e trace=file  -p 1      #文件操作,  file operator 
strace -e trace=process  -p 1 	#跟踪进程 
strace -e trace=network 		#网络 
strace -e signal=!io 			#不跟踪  SIGIO信号.
strace -e open lspci 			#查lspci 使用的  数据库文件. 
strace -o /tmp/ip_link_output.log  ip link		#output file
strace -f -trace=file -p $(pidof  xinetd) 		#trace fork subprocess , bgp rlogin nopasswd
strace -e ioctl  ifconfig		#ifconfig ioctl 的调用. 
strace -e read=3,5  			#read 从 3 5 端口 读取的数据.

EOF
;
}
sub all()
{
	print <<EOF
#2010_12_23_ add by greshem

需要跟踪的类型. 
strace  -e trace=file  -p 13479     
strace -f -o configure-strace.txt -e execve ./configure 跟踪 execve 命令. 
########################################################################
-eopen等价于 -e trace=open,表示只跟踪open调用.而-etrace!=open表示跟踪除了open以外的其他调用.有两个特别的符号 all 和 none.
注意有些shell使用!来执行历史记录里的命令,所以要使用＼＼.
-e trace=set
只跟踪指定的系统调用.例如:-e trace=open,close,rean,write表示只跟踪这四个系统调用.默认的为set=all.
-e trace=file
只跟踪有关文件操作的系统调用.
-e trace=process
只跟踪有关进程控制的系统调用.
-e trace=network
跟踪和网络有关的所有系统调用.
-e strace=signal
跟踪所有和系统信号有关的系统调用
-e trace=ipc
跟踪所有和进程通讯有关的系统调用
-e abbrev=set
设定strace输出的系统调用的结果集.-v 等和 abbrev=none.默认为abbrev=all.
-e raw=set
将指定的系统调用的参数以十六进制显示.
-e signal=set
指定跟踪的系统信号.默认为all.如signal=!SIGIO(或signal=!io),表示不跟踪SIGIO信号.
-e read=set
输出从指定文件中读出的数据.例如:
-e read=3,5
-e write=set
//########################################################################

结合gdb ， 从GDB 里面获取 一个进程的所有的线程， info threads 输出之后， 再提取
PID 然后， strace -p pid 然后， 就可以跟踪每个线程了. 跟踪一下所有的线程， 定时之后， 然后再把 STRACE 杀死掉， 然后， 可以跟踪出来每个进程特定时刻的IO， 再寻找， 每个阻塞的进程，  
EOF
;

}

