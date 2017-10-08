#!/usr/bin/perl
#gdb 7.5
sub deal_with_7_5()
{

#==========================================================================
#binutils gdb 都可以用下面的方式, 只 正对 一个 版本.
print <<EOF
grep ARCH_ opcodes/disassemble.c |grep ^#ifdef |awk '{print \$2}'  |sed 's/ARCH_//g' > arch

for each in \$(cat arch ); do mkdir build_\$each; done
for each in \$(cat arch ); do echo  "../configure --target=\$each-elf --program-prefix=\$each-elf- " > build_\$each/start.sh ; done
for each in \$(cat arch ); do echo  "make -j 8 " >> build_\$each/start.sh ; done


for_each_dir.pl "bash start.sh > /dev/null 2>&1 " 
EOF
;
}

if( ! -f "opcodes/disassemble.c")
{
	warn("#ERROR: cur dir is not in  gdb extract src code dir \n");
}
deal_with_7_5();
