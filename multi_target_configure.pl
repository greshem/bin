#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#==========================================================================
#binutils gdb 都可以用下面的方式, 只 正对 一个 版本.
grep ARCH_ opcodes/disassemble.c |grep ^#ifdef |awk '{print $2}'  |sed 's/ARCH_//g' > arch

for each in $(cat arch ); do mkdir build_$each; done
for each in $(cat arch ); do echo  "../configure --target=$each-elf --program-prefix=$each-elf- " > build_$each/start.sh ; done
for each in $(cat arch ); do echo  "make -j 8 " >> build_$each/start.sh ; done


for_each_dir.pl "bash start.sh > /dev/null 2>&1 " 

#==========================================================================
#yum install gcc* #f18 i386 
make ARCH=arm CROSS_COMPILE=arm-linux-gnu-   -j8 

for each in $(find arch/ -maxdepth 1 -mindepth 1 -type d )
do
name=$(echo $each |sed 's/arch\///g' ) 
echo rm -f vmlinux
echo make ARCH=$name CROSS_COMPILE=$name-linux-gnu-   allnoconfig  
echo make ARCH=$name CROSS_COMPILE=$name-linux-gnu-   -j8 
echo cp vmlinux  vmlinux_$name
done
