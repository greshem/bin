#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#2011_03_23_10:25:57   星期三   add by greshem
1. 默认的 f13_x64 的光盘是缺少 syslinux 的包的, 需要下载. 
	syslinux-3.84-1.fc13.i686.rpm 应该可以查到的, /root/mobile_harddisk_skeletion/
				/root/d_root_data/syslinux-3.84-1.fc13.i686.rpm
	依赖的crypt /root/d_root_data/perl-Crypt-PasswdMD5-1.3-6.fc13.noarch.rpm

2. 
然后会出现. 
  File "/usr/share/yum-cli/callback.py", line 196, in callback
	UnicodeEncodeError: 'ascii' codec can't encode characters in position 3-6: ordinal not in range(128)

#sys.stdout.write(msg)
##sys.stdout.flush()
# 原因查下来是  stdout 当然不会处理  utf8 等编码的模式了， 这里的意思是打印
# 直接用print 来替代就可以了。
print msg;

########################################################################
2. 
########################################################################
#!/bin/bash
#['/sbin/mksquashfs', '/var/tmp/imgcreate-Oakqee/iso-91VKrC/LiveOS/osmin', '/var/tmp/imgcreate-Oakqee/iso-91VKrC/LiveOS/osmin.img', '-no-progress']
#################mksquashfs() ###########################################
#['/sbin/mksquashfs', '/var/tmp/imgcreate-Oakqee/tmp-UuSHNE', '/var/tmp/imgcreate-Oakqee/iso-91VKrC/LiveOS/squashfs.img', '-no-progress']
############################### mkisofs ###############
#['/usr/bin/mkisofs', '-J', '-r', '-hide-rr-moved', '-hide-joliet-trans-tbl', '-V', 'fedora-minimal-i686-201008300438', '-o', '/var/tmp/imgcreate-Oakqee/out/livecd-fedora-minimal_v3-201008300438.iso', '-b', 'isolinux/isolinux.bin', '-c', 'isolinux/boot.cat', '-no-emul-boot', '-boot-info-table', '-boot-load-size', '4', '/var/tmp/imgcreate-Oakqee/iso-91VKrC']
#####################################################################################################################
#####################################################################################################################
#####################################################################################################################

#/sbin/mksquashfs   ext3_img/  iso-91VKrC/LiveOS/squashfs.img  -no-progress
#
#2010_08_30_10:40:46 add by greshem
#上面都是 用 /usr/bin/livecd-creator 的dump的过程. 对每次的 mksquash mkisofs 进行调用 的完整的命令行, 可以都不看.
##############################
##############################
##############################
##############################
#注意 mkisofs 使用的-V 的选项, 和 iso-linux/isolinux/isolinux.cfg 里面 的 root=live:CDLABEL=fedora-minimal-i686-201008300438  要相同, 否则不能启动. 
#还有注意 livecd-creator  -c livecd-fedora-minimal_v3.ks   这一步的时候， 假如出现中断设置的是中文的话， python  直接用 fd 来操作中断导致错误， write(stderr, unicode_str) 最后修改成 print unicode_str就可以了。 
 
#1. 用vim 把  /usr/lib/python2.6/site-packages/imgcreate/ 打开
#2. 安装 Grep 插件.  
#3. 对每一行的rmtree 进行注释, 打印, python 的打印可以参考 /root/develop_python/print.py 的语法. 
#4. 把iso-* 重新命名为 iso-linux 
mv iso-6dV33r/ iso-linux
#5 把 tmp-* 重新命名为 ext3_img. 
mv tmp-h9pyex/ ext3_img

rm -f iso-linux/LiveOS/squashfs.img  

/sbin/mksquashfs   ext3_img/  iso-linux//LiveOS/squashfs.img  

cd iso-linux/
/usr/bin/mkisofs -J -r -hide-rr-moved  -hide-joliet-trans-tbl  -V  fedora-minimal-i686-201008300438  -o  /tmp/livecd-fedora-minimal_v3-201008300438.iso  -b  isolinux/isolinux.bin  -c  isolinux/boot.cat  -no-emul-boot  -boot-info-table  -boot-load-size  4  $(pwd)/


