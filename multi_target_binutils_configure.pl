#!/usr/bin/perl
#binutils 2.22 
sub deal_with_2_22()
{

#==========================================================================
#binutils gdb ������������ķ�ʽ, ֻ ���� һ�� �汾.
print <<EOF
grep ARCH_ opcodes/disassemble.c |grep ^#ifdef |awk '{print \$2}'  |sed 's/ARCH_//g' > arch

for each in \$(cat arch ); do mkdir build_\$each; done
for each in \$(cat arch ); do echo  "../configure --target=\$each-elf --program-prefix=\$each-elf- " > build_\$each/start.sh ; done
for each in \$(cat arch ); do echo  "make -j 8 " >> build_\$each/start.sh ; done


for_each_dir.pl "bash start.sh > /dev/null 2>&1 " 
EOF
;
}


deal_with_2_22();
