#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#�������ο� 
#G:\sdb1\_xfile\2013_all_iso\_xfile_2013_03\_release\HP_OEM_2013_03_release\hp_oem_����_ָ��_.txt
########################################################################
1. Դ�� ����
2. c:\\works\\

3. ȡ��  rtiosrv �� 829 �İ汾
	#bug svn update -r 829   ��Ҫ��ȥ500
		svn update -r 329  

3.   /bin/wxWidgets-2.8.10_build_msw.pl
4.   /bin/file_slurp_sed_wxwidgets_broadcast.pl 
		���������������  wxSOCKET_BROADCAST 
5.   manager û�� BoradCast() �ĺ��� 
		manager/Remoate.cpp ����ע�͵� 
//dest.BroadcastAddress() ; 
	

6.  build.bkl ��� ע���� LIBCMT �Լ� LIBCMD ֮�������,  
	rtiosrv manager  subman ����  ����Ҫ���  LIBCMT.lib 
		<ldflags>/NODEFAULTLIB:LIBCMT.lib</ldflags>
		�ŵ�  ������е�ǰ��. 
        <lib-path>shared</lib-path>


7.  bake release 
	#֮�� 
		sed 's/MT/MD/g' Makefile 
	#��� wxStringData::Free(void) ������. 


8. ���� ��Makefile 242 ���еĵط� �Լ����
		/NODEFAULTLIB:LIBCMT.lib 
9. import   VER_HPOEM һ��Ҫ����. 
	    <define>VER_ENTERPRISE</define>
		<define>VER_HPOEM</define>
