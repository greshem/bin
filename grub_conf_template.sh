#!/bin/bash

cat <<EOF
#splashimage=(hd0,0)/boot/grub/splash.xpm.gz
default=0
timeout=5
title Other 
	root (hd0,0)
	chainloader +1
	boot
title linux 
	root (hd0,3)
	kernel /boot/vmlinuz root=/dev/sda2 
	initrd /boot/initrd

EOF
