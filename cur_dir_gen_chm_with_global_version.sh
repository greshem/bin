#!/bin/bash
#2011_03_01_13:03:56   ���ڶ�   add by greshem
ver=$1;
log="/var/log/cur_dir_gen_chm_with_global_version.log"
if [ ! -d /root/globals_v2_f13_x64/global_bin/global-${ver}/ ];then
	echo ��֧�ֵİ汾��
	echo ��֧�ֵİ汾�� $ver >> $log 
	exit -1
fi
if [ ! -f /root/globals_v2_f13_x64/global_bin/global-${ver}/bin/gtags ];then
	echo gtags �ļ�������
	echo gtags �ļ������� >>$log
	exit -2;
fi
if [ ! -f /root/globals_v2_f13_x64/global_bin/global-${ver}/bin/htags ];then
	echo htags �ļ�������
	echo htags �ļ������� >> $log
	exit -2;
fi 

cp -a -r   /root/globals_v2_f13_x64/global_bin/global-${ver}/bin/* /usr/bin/
/root/globals_v2_f13_x64/global_bin/global-${ver}/bin/gtags 
/root/globals_v2_f13_x64/global_bin/global-${ver}/bin/htags -n
name=$(basename $(pwd))
if [ -d HTML ];then
cd HTML 
else 
 	echo "globals ������"
	exit -1
fi

#/bin/chm_template_build_v2.sh
#�� /bin/chm_template_build_v2.sh dump �������3��. 

template_HHC_v2.pl 
template_HHK_v2.pl
template_HPP_v2.pl 

chmod -R 000 /tmp/.wine*  

wine hhc.exe HTML.hpp
if [ -f  HTML.chm ];then
mv HTML.chm ../${name}.chm
cd ..
fi

rm -rf HTML

