#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#########
# 锐起的是 2.8.10 版本的。 
#不过注意这个版本， 不能在 f13 上面正确的编译， 因为gsockgtk 的接口已经变掉了， 所以可以通过 不用gtk 的底层驱动来实现， 
#通过 ./configure --with-x11 可以的

######下面是锐起的编译的方式。 
# 个人的和 锐起的是 2.8.10 版本的。 

#==========================================================================
bakefile  
./configure --prefix=/usr/

#==========================================================================
if [ ! -f /tmp/wxWidgets-2.8.11.tar.gz ];then
	echo "Usage wxWidgets not exists \n";
	exit 
fi

yum -y  install gtk* vim* subversion libusb* gcc* font*  xorg-x11-font*  gdb*  xinetd* tftp* dhcp* nmap iptraf iptraf-ng
yum -y  font*		#manager 用来显示的中文字体, 否则 无论 utf8 gb2312 都不能正常显示.
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

#rtiosrv xfile 的11 月份 dlxp 可以查找到. 
之后再安装 bakefile 到了srv 目录直接执行 , bake, 就ok, 
可能会碰到 bakefile 不再能执行的问题， 参考
<<bakefile_python修改.txt>>  文档. 
########################################################################
#2011_03_09_14:33:58   星期三   add by greshem
编译 /root/wxWidget_demo_unittest/wxDatetime.cpp 出现inlcude 没有setup.h 的文件. 

 需要把 ./buildgtk/lib/wx/include/gtk2-unicode-release-static-2.8/wx/setup.h 拷贝到
cp lib/wx/include/gtk2-unicode-release-static-2.8/wx/setup.h  /usr/local/include/wx-2.8/wx/
之后后 wxDatetime.cpp 就可以顺利编译了. 



#2012_06_17_22:31:53   星期日   add by greshem
#1. 为了避免  一些例外的编译请看  选用 2.8.7 的没有什么问题了
#2. 编译安装好之后  然后 到 rtiosrv 源码目录  bash bake  就会提示是 release 
#	bash bake  debug 
#	之后 再 make  就可以编译出对应的项目了.  
#3. 
