#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#2011_03_23_10:25:57   ������   add by greshem
1. Ĭ�ϵ� f13_x64 �Ĺ�����ȱ�� syslinux �İ���, ��Ҫ����. 
	syslinux-3.84-1.fc13.i686.rpm Ӧ�ÿ��Բ鵽��, /root/mobile_harddisk_skeletion/
				/root/d_root_data/syslinux-3.84-1.fc13.i686.rpm
	������crypt /root/d_root_data/perl-Crypt-PasswdMD5-1.3-6.fc13.noarch.rpm

2. 
Ȼ������. 
  File "/usr/share/yum-cli/callback.py", line 196, in callback
	UnicodeEncodeError: 'ascii' codec can't encode characters in position 3-6: ordinal not in range(128)

#sys.stdout.write(msg)
##sys.stdout.flush()
# ԭ���������  stdout ��Ȼ���ᴦ��  utf8 �ȱ����ģʽ�ˣ� �������˼�Ǵ�ӡ
# ֱ����print ������Ϳ����ˡ�
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
#���涼�� �� /usr/bin/livecd-creator ��dump�Ĺ���. ��ÿ�ε� mksquash mkisofs ���е��� ��������������, ���Զ�����.
##############################
##############################
##############################
##############################
#ע�� mkisofs ʹ�õ�-V ��ѡ��, �� iso-linux/isolinux/isolinux.cfg ���� �� root=live:CDLABEL=fedora-minimal-i686-201008300438  Ҫ��ͬ, ����������. 
#����ע�� livecd-creator  -c livecd-fedora-minimal_v3.ks   ��һ����ʱ�� ��������ж����õ������ĵĻ��� python  ֱ���� fd �������жϵ��´��� write(stderr, unicode_str) ����޸ĳ� print unicode_str�Ϳ����ˡ� 
 
#1. ��vim ��  /usr/lib/python2.6/site-packages/imgcreate/ ��
#2. ��װ Grep ���.  
#3. ��ÿһ�е�rmtree ����ע��, ��ӡ, python �Ĵ�ӡ���Բο� /root/develop_python/print.py ���﷨. 
#4. ��iso-* ��������Ϊ iso-linux 
mv iso-6dV33r/ iso-linux
#5 �� tmp-* ��������Ϊ ext3_img. 
mv tmp-h9pyex/ ext3_img

rm -f iso-linux/LiveOS/squashfs.img  

/sbin/mksquashfs   ext3_img/  iso-linux//LiveOS/squashfs.img  

cd iso-linux/
/usr/bin/mkisofs -J -r -hide-rr-moved  -hide-joliet-trans-tbl  -V  fedora-minimal-i686-201008300438  -o  /tmp/livecd-fedora-minimal_v3-201008300438.iso  -b  isolinux/isolinux.bin  -c  isolinux/boot.cat  -no-emul-boot  -boot-info-table  -boot-load-size  4  $(pwd)/


