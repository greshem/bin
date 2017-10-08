#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#!/bin/bash
hostip=0.0.0.0#本机的ip.
########################################################################
#windows 2000
if [ ! -f   windows2000.img  ];then
	qemu-img create windows2000.img 10G
fi
qemu-kvm -m 256 -hda windows2000.img -cdrom /tmp2/cn_win2000_pro_with_sp4.iso -boot d  -localtime -vnc 0.0.0.0:1  -daemonize  

########################################################################
#windows xp
if [ ! -f   windowsxp.img  ];then
	qemu-img create windowsxp.img 10G
fi
#qemu-kvm -hda windowsxp.img -cdrom /tmp2/winxp+sp2.ISO -boot d -m 512 -localtime -vnc 0.0.0.0:2 #鼠标键盘不支持了.
qemu-kvm -m 256 -hda windowsxp.img -hdb windowsxp.img.bak -cdrom /tmp2/MS.Windows_XP_Professional_Corporate_VLK_SP3.CN.iso -boot d  -localtime -vnc 0.0.0.0:2  -daemonize  

########################################################################
#win2003
if [ ! -f windows2003.img ];then
	qemu-img create windows2003.img 10G
fi
qemu-kvm -m 256 -hda windows2003.img -cdrom /tmp2/Windows.Server.2003_SP2.ISO -boot d  -localtime -vnc 0.0.0.0:3  -daemonize  


########################################################################
#win7
if [ ! -f windows7.img ];then
	qemu-img create windows7.img 10G
fi
qemu-kvm -m 512 -hda windows7.img -cdrom /tmp2/cn_windows_7_ultimate_x86_dvd_x15-65907.iso -boot d -localtime -vnc 0.0.0.0:4  -daemonize  


#f8
if [ ! -f   f8.img  ];then
	qemu-img create f8.img 10G
fi

#qemu-kvm -m 128 -hda f8.img  -cdrom /tmp2/f8_i386.iso  -boot c -localtime -vnc 0.0.0.0:5  -net nic,vlan=0 -net user,vlan=0  -daemonize  
qemu-kvm -m 128 -hda f8.img  -cdrom /tmp2/f8_i386.iso  -boot c -localtime -vnc 0.0.0.0:5  -net nic -net user  -daemonize  
qemu-kvm -m 128 -hda f8.img  -cdrom /tmp2/f8_i386.iso  -boot c -localtime -vnc 0.0.0.0:5    -net nic,vlan=0 -net tap,vlan=0,ifname=tap0,script=no  -daemonize  
#


########################################################################
#win2008
if [ ! -f windows2008.img ];then
	qemu-img create windows2008.img 10G
fi
qemu-kvm -m 512 -hda windows2008.img -cdrom /tmp2/cn_windows_web_server_2008_with_sp2_x86_dvd_x15-51050.iso  -boot d -localtime -vnc 0.0.0.0:8  -daemonize  

