#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__

svn co http://192.168.1.16/svn/aix_ibm_cli_usage 	aix_ibm_cli_usage
svn co http://192.168.1.16/svn/bin_2012_1121_ 		bin_2012_1121_
svn co http://192.168.1.16/svn/bin_2012_11_22_bug 	bin_2012_11_22_bug
svn co http://192.168.1.16/svn/bin 					bin
svn co http://192.168.1.16/svn/bin_bak_20121011_5 	bin_bak_20121011_5
svn co http://192.168.1.16/svn/bin_win7 			bin_win7
svn co http://192.168.1.16/svn/daemon_monitor 		daemon_monitor
svn co http://192.168.1.16/svn/data_collecting 		data_collecting
svn co http://192.168.1.16/svn/develop_bash 		develop_bash
svn co http://192.168.1.16/svn/develop_cpp 			develop_cpp
svn co http://192.168.1.16/svn/develop_ddk 			develop_ddk
svn co http://192.168.1.16/svn/develop_etc 			develop_etc
svn co http://192.168.1.16/svn/develop_kernel 		develop_kernel
svn co http://192.168.1.16/svn/develop_mfc 			develop_mfc
svn co http://192.168.1.16/svn/develop_network 		develop_network
svn co http://192.168.1.16/svn/develop_perl 		develop_perl
svn co http://192.168.1.16/svn/develop_perl_windows develop_perl_windows
svn co http://192.168.1.16/svn/develop_php 			develop_php
svn co http://192.168.1.16/svn/develop_python 		develop_python
svn co http://192.168.1.16/svn/develop_qemu_kvm 	develop_qemu_kvm
svn co http://192.168.1.16/svn/develop_reg_registry 	develop_reg_registry
svn co http://192.168.1.16/svn/develop_sed_txt_tools 	develop_sed_txt_tools
svn co http://192.168.1.16/svn/develop_thread 			develop_thread
svn co http://192.168.1.16/svn/develop_wxwidgets 		develop_wxwidgets
svn co http://192.168.1.16/svn/develop_wxwidgets_73 	develop_wxwidgets_73
svn co http://192.168.1.16/svn/develop_xxunit 			develop_xxunit
svn co http://192.168.1.16/svn/diskless_linux 			diskless_linux
svn co http://192.168.1.16/svn/diskless_rich_536 		diskless_rich_536
svn co http://192.168.1.16/svn/diskless_rich_687 		diskless_rich_687
svn co http://192.168.1.16/svn/diskplat 				diskplat
svn co http://192.168.1.16/svn/doc 						doc
svn co http://192.168.1.16/svn/doc_collaboration_tnsoft doc_collaboration_tnsoft
svn co http://192.168.1.16/svn/global-4.4_logger 		global-4.4_logger
svn co http://192.168.1.16/svn/home_234_profile 		home_234_profile
svn co http://192.168.1.16/svn/include_structs_code_generator 	include_structs_code_generator
svn co http://192.168.1.16/svn/io_device_manager 				io_device_manager
svn co http://192.168.1.16/svn/iso_index_and_search 			iso_index_and_search
svn co http://192.168.1.16/svn/linux 						linux
svn co http://192.168.1.16/svn/linux2 						linux2
svn co http://192.168.1.16/svn/lmyunit 						lmyunit
svn co http://192.168.1.16/svn/logtrans_srv_new_v5 			logtrans_srv_new_v5
svn co http://192.168.1.16/svn/math_tools_v2 				math_tools_v2
svn co http://192.168.1.16/svn/old 							old
svn co http://192.168.1.16/svn/pkg_develop 					pkg_develop
svn co http://192.168.1.16/svn/project_collaboration 		project_collaboration
svn co http://192.168.1.16/svn/qzjProject 					qzjProject
svn co http://192.168.1.16/svn/random_things_v3 			random_things_v3
svn co http://192.168.1.16/svn/structs_code_generator 		structs_code_generator
svn co http://192.168.1.16/svn/svn_merge_tools 				svn_merge_tools
svn co http://192.168.1.16/svn/svn_trunk_tags_branches 		svn_trunk_tags_branches
svn co http://192.168.1.16/svn/sync 						sync
svn co http://192.168.1.16/svn/system_initialization_win 	system_initialization_win
svn co http://192.168.1.16/svn/test 						test
svn co http://192.168.1.16/svn/vim_common 					vim_common
svn co http://192.168.1.16/svn/volume_shadow_tools 			volume_shadow_tools
svn co http://192.168.1.16/svn/_xfile 						_xfile


[RICH]
svn co http://192.168.1.16/svn/diskless_clntools2 	diskless_clntools2
svn co http://192.168.1.16/svn/web_gamemenu 		web_gamemenu
svn co http://192.168.1.16/svn/ww_gamemenu 			ww_gamemenu
svn co http://192.168.1.16/svn/ww_netclone 			ww_netclone
svn co http://192.168.1.16/svn/RealMonitor 			RealMonitor
svn co http://192.168.1.16/svn/rich3_1_262 			rich3_1_262
svn co http://192.168.1.16/svn/richdlxp 			richdlxp
svn co http://192.168.1.16/svn/richdlxp4 			richdlxp4
svn co http://192.168.1.16/svn/richdlxp_cp 			richdlxp_cp
svn co http://192.168.1.16/svn/richtech-scripts_rpm richtech-scripts_rpm
svn co http://192.168.1.16/svn/rich_addvalue2 		rich_addvalue2
svn co http://192.168.1.16/svn/rich_ad_system 		rich_ad_system
svn co http://192.168.1.16/svn/rich_backup 			rich_backup
svn co http://192.168.1.16/svn/rich_bt2 			rich_bt2
svn co http://192.168.1.16/svn/rich_servercontrol 	rich_servercontrol
svn co http://192.168.1.16/svn/dlxp_bootldr 		dlxp_bootldr
svn co http://192.168.1.16/svn/dlxp_bootldr_asua_26 dlxp_bootldr_asua_26
svn co http://192.168.1.16/svn/dlxp_windrv 			dlxp_windrv
svn co http://192.168.1.16/svn/dlxp_windrv_69 		dlxp_windrv_69
svn co http://192.168.1.16/svn/netware_emulator 			netware_emulator
svn co http://192.168.1.16/svn/netware_emulator_73_1159 	netware_emulator_73_1159
svn co http://192.168.1.16/svn/netware_emulator_f8_1163 	netware_emulator_f8_1163
svn co http://192.168.1.16/svn/netware_emulator_rich_1090 	netware_emulator_rich_1090
svn co http://192.168.1.16/svn/vdisk_tcp_client 			vdisk_tcp_client
svn co http://192.168.1.16/svn/virtual_desk_system 			virtual_desk_system


[WEB]: 
svn co http://192.168.1.16/svn/develop_js 			develop_js
svn co http://192.168.1.16/svn/auqatic_pond_2014 	auqatic_pond_2014
svn co http://192.168.1.16/svn/qianlong_webadmin_v2 qianlong_webadmin_v2
svn co http://192.168.1.16/svn/petty_china 			2010_petty_china		#2010年修改的, 2012 提交到svn 的.
svn co http://192.168.1.16/svn/petty_china_new 		2012_petty_china_new
svn co http://192.168.1.16/svn/petty_new_site 		2012_petty_new_site # 来自于 fontal-cn
svn co http://192.168.1.16/svn/develop_webworks 	2012_develop_webworks
svn co http://192.168.1.16/svn/xboot3 				2013_xboot3
svn co http://192.168.1.16/svn/11698666 11698666
svn co http://192.168.1.16/svn/11698666_v2 			2011_11698666_v2
svn co http://192.168.1.16/svn/sino_pet 			2012_sino_pet
svn co http://192.168.1.16/svn/file_explorer_manager_web_index file_explorer_manager_web_index
svn co http://192.168.1.16/svn/foreign_trade_management_sys foreign_trade_management_sys
svn co http://192.168.1.16/svn/conftools 			conftools
