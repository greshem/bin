#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#########
# ������� 2.8.10 �汾�ġ� 
#����ע������汾�� ������ f13 ������ȷ�ı��룬 ��Ϊgsockgtk �Ľӿ��Ѿ�����ˣ� ���Կ���ͨ�� ����gtk �ĵײ�������ʵ�֣� 
#ͨ�� ./configure --with-x11 ���Ե�

######����������ı���ķ�ʽ�� 
# ���˵ĺ� ������� 2.8.10 �汾�ġ� 

#==========================================================================
bakefile  
./configure --prefix=/usr/

#==========================================================================
if [ ! -f /tmp/wxWidgets-2.8.11.tar.gz ];then
	echo "Usage wxWidgets not exists \n";
	exit 
fi

yum -y  install gtk* vim* subversion libusb* gcc* font*  xorg-x11-font*  gdb*  xinetd* tftp* dhcp* nmap iptraf iptraf-ng
yum -y  font*		#manager ������ʾ����������, ���� ���� utf8 gb2312 ������������ʾ.
yum -y  xorg-x11-font* 
yum -y  install gnome*

cd /tmp/
tar -xzvf wxWidgets-2.8.10.tar.gz -C . 
cd /tmp/wxWidgets-2.8.10
mkdir buildgtk
cd buildgtk
../configure --with-gtk --enable-unicode --disable-shared --prefix=/usr
make
make install
cd /etc/ld.so.conf.d
echo "/usr/lib" > wx.conf
ldconfig

#rtiosrv xfile ��11 �·� dlxp ���Բ��ҵ�. 
֮���ٰ�װ bakefile ����srv Ŀ¼ֱ��ִ�� , bake, ��ok, 
���ܻ����� bakefile ������ִ�е����⣬ �ο�
<<bakefile_python�޸�.txt>>  �ĵ�. 
########################################################################
#2011_03_09_14:33:58   ������   add by greshem
���� /root/wxWidget_demo_unittest/wxDatetime.cpp ����inlcude û��setup.h ���ļ�. 

 ��Ҫ�� ./buildgtk/lib/wx/include/gtk2-unicode-release-static-2.8/wx/setup.h ������
cp lib/wx/include/gtk2-unicode-release-static-2.8/wx/setup.h  /usr/local/include/wx-2.8/wx/
֮��� wxDatetime.cpp �Ϳ���˳��������. 



#2012_06_17_22:31:53   ������   add by greshem
#1. Ϊ�˱���  һЩ����ı����뿴  ѡ�� 2.8.7 ��û��ʲô������
#2. ���밲װ��֮��  Ȼ�� �� rtiosrv Դ��Ŀ¼  bash bake  �ͻ���ʾ�� release 
#	bash bake  debug 
#	֮�� �� make  �Ϳ��Ա������Ӧ����Ŀ��.  
#3. 
