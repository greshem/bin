#!/usr/bin/perl

use Cwd;
use File::Basename;

our $g_pwd=getcwd();
our $g_basename=basename($g_pwd);
our $g_dirname=dirname($g_pwd);

my @files=glob("*.c");
if(scalar(@files) eq 0)
{
	usage();	 
}

if( ! -f "Makefile")
{
	gen_Makefile();
}
else
{
	print ("#Makefile  exists, please delete it by yourself; \n");
	print ("mv Makefile Makefile.bak \n");
	print ("#And then merge Makefile and Makefile.bak , for  automation  \n");
}


sub gen_Makefile()
{
	open(FILE, ">Makefile") or die("create  Makefile ,  error \n");

print FILE <<EOF

.PHONY: default clean

obj-m := $g_basename.o
#kfile_test-objs := ../kfile.o
KDIR  := /lib/modules/\$(shell uname -r)/build
PWD   := \$(shell pwd)

#EXTRA_LDFLAGS := -l../kfile.o

default:
	\$(MAKE) -C \$(KDIR) M=\$(PWD) modules

clean:
	rm -rf *.ko *.o *.mod.* .H* .tm* .*cmd Module.symvers .*.o.d modules.order  *.ko.unsigned
insert:
	insmod $g_basename.ko
rmmod:
	rmmod $g_basename
vim:
	vim $g_basename.c

EOF
;
	close();
	
}

sub usage()
{
	print <<EOF
#注意是 M=\$(pwd)  和 -M=\$(pwd) 之间的区别. 
#==========================================================================
#usbip 
make KSOURCE=/lib/modules/\$(uname -r)/build   #all rhel
make KSOURCE=/lib/modules/2.6.9-89.EL/build   #rhel4.8  kernel


#M= 表示模块的路径.
make -C /lib/modules/\$(uname -r)/build M=\$(pwd)  modules      
make -C /usr/src/`uname -r` M=`pwd` modules

make -C \$(KERNELDIR) M=\$(PWD) modules


make -C ../   		M=\$(pwd)  modules  
make -C ../../   	M=\$(pwd)  modules  
make -C ../../../   M=\$(pwd)  modules  
#==========================================================================
#openvswitch 1.2.0
#Ubuntu 11.10  server  version 
# ./configure --with-l26=/lib/modules/`uname -r`/build
#
EOF
;
}
