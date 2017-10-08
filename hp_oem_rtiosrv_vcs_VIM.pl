#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#服务器参看 
#G:\sdb1\_xfile\2013_all_iso\_xfile_2013_03\_release\HP_OEM_2013_03_release\hp_oem_部署_指南_.txt
########################################################################
1. 源码 编译
2. c:\\works\\

3. 取到  rtiosrv 的 829 的版本
	#bug svn update -r 829   需要减去500
		svn update -r 329  

3.   /bin/wxWidgets-2.8.10_build_msw.pl
4.   /bin/file_slurp_sed_wxwidgets_broadcast.pl 
		解决代码编译的问题  wxSOCKET_BROADCAST 
5.   manager 没有 BoradCast() 的函数 
		manager/Remoate.cpp 代码注释掉 
//dest.BroadcastAddress() ; 
	

6.  build.bkl 添加 注意是 LIBCMT 以及 LIBCMD 之间的区别,  
	rtiosrv manager  subman 都是  都需要添加  LIBCMT.lib 
		<ldflags>/NODEFAULTLIB:LIBCMT.lib</ldflags>
		放到  下面的行的前面. 
        <lib-path>shared</lib-path>


7.  bake release 
	#之后 
		sed 's/MT/MD/g' Makefile 
	#解决 wxStringData::Free(void) 的问题. 


8. 或者 在Makefile 242 的行的地方 自己添加
		/NODEFAULTLIB:LIBCMT.lib 
9. import   VER_HPOEM 一定要设置. 
	    <define>VER_ENTERPRISE</define>
		<define>VER_HPOEM</define>
