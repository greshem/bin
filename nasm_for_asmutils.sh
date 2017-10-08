#!/bin/bash
#2011_03_18_22:18:43 add by qzj
#nasm -w+orphan-labels -w+macro-params -i../inc/ -O99v -f bin -D__LINUX__ -D__KERNEL__=24 -D__SYSCALL__=__S_KERNEL__ -D__OPTIMIZE__=__O_SIZE__ -D__ELF__ -D__ELF_MACROS__ 
#  下面的两个宏是必须的.  __LINUX__ 说明 了操作系统. __ELF_MACROS__ 只会生成data 文件 不是elf 格式. 
# 下面用来编译 asmutils src 目录下的所有的命令. 
# 只在 32位下才可以编译成功. 
for each in $(dir -1 |grep asm$)
do

echo nasm -w+orphan-labels -w+macro-params -i../inc/ -O99v -f bin   -D__LINUX__  -D__ELF__ -D__ELF_MACROS__  $each
nasm -w+orphan-labels -w+macro-params -i../inc/ -O99v -f bin   -D__LINUX__  -D__ELF__ -D__ELF_MACROS__  $each
done
