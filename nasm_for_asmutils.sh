#!/bin/bash
#2011_03_18_22:18:43 add by qzj
#nasm -w+orphan-labels -w+macro-params -i../inc/ -O99v -f bin -D__LINUX__ -D__KERNEL__=24 -D__SYSCALL__=__S_KERNEL__ -D__OPTIMIZE__=__O_SIZE__ -D__ELF__ -D__ELF_MACROS__ 
#  ������������Ǳ����.  __LINUX__ ˵�� �˲���ϵͳ. __ELF_MACROS__ ֻ������data �ļ� ����elf ��ʽ. 
# ������������ asmutils src Ŀ¼�µ����е�����. 
# ֻ�� 32λ�²ſ��Ա���ɹ�. 
for each in $(dir -1 |grep asm$)
do

echo nasm -w+orphan-labels -w+macro-params -i../inc/ -O99v -f bin   -D__LINUX__  -D__ELF__ -D__ELF_MACROS__  $each
nasm -w+orphan-labels -w+macro-params -i../inc/ -O99v -f bin   -D__LINUX__  -D__ELF__ -D__ELF_MACROS__  $each
done
