#!/usr/bin/perl 
#use strict;
#use warnings;
#G:\sdb2\linux_src_iso
#Security_iso
#注意: 这里不要引号.
#cygwin 下 
#find  /cygdrive/j/  -type d  |sed 's|/cygdrive/j/|sdb1:/|g' |sed 's/\//\\\\/g' |sed 's/$/\\\\/g'  
#find  /cygdrive/j/  -type d  |sed 's|/cygdrive/j/|sdb1:/|g' |sed 's/\//\\\\/g' |sed 's/$/\\\\/g'   
#过滤条件: egrep -v 'TDownload|_bak_2_del|System Volume Information|2014_01|_xfile_2013_12|sdb2|RECYCLE.BIN|KuGouCache|程程看的|\\dir\\'
@g_iso_paths= qw(


sdb1:\\sdb1\\
sdb1:\\sdb1\\_x_file_ext\\
sdb1:\\sdb1\\_x_file_ext\\WINDWOS_symbol\\
sdb1:\\sdb1\\_x_file_ext\\zzu_ebook\\
sdb1:\\sdb1\\_x_file_ext\\zzu_ebook_computer\\
sdb1:\\sdb1\\_xfile\\
sdb1:\\sdb1\\_xfile\\2009_all_iso\\
sdb1:\\sdb1\\_xfile\\2010_all_iso\\
sdb1:\\sdb1\\_xfile\\2011_all_iso\\
sdb1:\\sdb1\\_xfile\\2012_all_iso\\
sdb1:\\sdb1\\_xfile\\2013_all_iso\\
sdb1:\\sdb1\\_xfile\\2014_all_iso\\
sdb1:\\sdb1\\_xfile\\2015_all_iso\\
sdb1:\\sdb1\\_xfile\\d_qianlong_all_iso\\
sdb1:\\sdb1\\all_chm\\
sdb1:\\sdb1\\dos_iso\\
sdb1:\\sdb1\\ebook\\
sdb1:\\sdb1\\game\\
sdb1:\\sdb1\\iso_dv_HOME\\
sdb1:\\sdb1\\jianpu.cn\\
sdb1:\\sdb1\\kugou_mp3_iso\\
sdb1:\\sdb1\\onegreen\\
sdb1:\\sdb1\\oss_site_all_iso\\
sdb1:\\sdb1\\oss_site_all_iso\\d_python_pypi_mirror_iso\\
sdb1:\\sdb1\\oss_site_all_iso\\d_python_pypi_mirror_iso\\old\\
sdb1:\\sdb1\\sf_mirror_iso\\
sdb1:\\sdb1\\software_ext_iso\\
sdb1:\\sdb1\\software_ext_iso\\gentoo_portage_chm_2015\\
sdb1:\\sdb1\\software_ext_iso\\xcode_4.2_and_ios_5_sdk_for_snow_leopard\\
sdb1:\\sdb1\\software_iso\\
sdb1:\\sdb1\\software_iso\\firefox_url_all_version\\
sdb1:\\sdb1\\software_iso\\ibm_Software\\
sdb1:\\sdb1\\software_iso\\ibm_aix_rpm_oss\\
sdb1:\\sdb1\\software_iso\\ibm_aix_system_director\\
sdb1:\\sdb1\\software_iso\\ibm_reversing_system_director\\
sdb1:\\sdb1\\software_iso\\koji_fedora_f16_x86_64_elf_extract\\
sdb1:\\sdb1\\software_iso\\koji_fedora_f18_i386_elf_extract\\
sdb1:\\sdb1\\software_iso\\lianhuanhua_all_iso\\
sdb1:\\sdb1\\software_iso\\loadrunner\\
sdb1:\\sdb1\\software_iso\\matlab_iso\\
sdb1:\\sdb3\\
sdb1:\\sdb3\\Green_software\\
sdb1:\\sdb3\\db\\
sdb1:\\sdb3\\develop_IDE_ISO\\
sdb1:\\sdb3\\lindows\\
sdb1:\\sdb3\\office_03_07_10\\
sdb1:\\sdb3\\office_03_07_10\\visio\\
sdb1:\\sdb3\\photo\\
sdb1:\\sdb3\\photo\\2016\\
sdb1:\\sdb3\\qimeng\\
sdb1:\\sdb3\\vc\\
sdb1:\\sdb3\\vc\\Borland_C++_Builder_6_原版\\
sdb1:\\sdb3\\vc\\MSDN2003\\
sdb1:\\sdb3\\vc\\VA\\
sdb1:\\sdb3\\vc\\VA\\old\\
sdb1:\\sdb3\\vc\\VS2008\\
sdb1:\\sdb3\\vc\\ddk\\
sdb1:\\sdb3\\vc\\intel_cc\\
sdb1:\\sdb3\\vc\\msdn_2001\\
sdb1:\\sdb3\\vc\\vc2003\\
sdb1:\\sdb3\\vc\\vc2003\\vs2003\\
sdb1:\\sdb3\\vc\\vc2003\\vs2003\\Visual assist .NET\\
sdb1:\\sdb3\\vc\\vc2003\\vs2003\\Visual assist .NET\\Crack\\
sdb1:\\sdb3\\vc\\vc2005\\
sdb1:\\sdb3\\vc\\vc6.0\\
sdb1:\\sdb3\\vc\\vc6.0\\vc_助手_1830_Assistant\\
sdb1:\\sdb3\\vc\\vs2010\\
sdb1:\\sdb3\\windows_pe_iso\\
sdb1:\\sdb4\\
sdb1:\\sdb4\\f13_srpm_download\\
sdb1:\\sdb4\\f13_srpm_download\\d_linux_src_f13\\
sdb1:\\sdb4\\f16_srpm\\
sdb1:\\sdb4\\f8_srpm_done\\
sdb1:\\sdb4\\tuku\\


);


