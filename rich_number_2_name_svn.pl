#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
0 access-control
1 access-control~
2 anti_arp_attack
3 bt2_client
4 bt_vdisk_drv
5 data_collecting
6 dev_ctrl_interface
7 diskless_clntools
8 diskless_clntools2
9 diskless_linux
10 diskless_oem
11 diskless_rich #bsd 3.1 °æ±¾.
12 dlxp_bootldr
13 dlxp_founder
14 dlxp_help
15 dlxp_tools
16 dlxp_windrv
17 dos_hotbackup
18 dos_menu
19 fulldisk
20 gameupdate_bt
21 hp_register
22 industry_addition
23 io_device_manager
24 netware_emulator
25 octopus_svdisk
26 personal_disk
27 police_login
28 post-commit
29 pre-commit-log.bat@echo_off
30 pre-revprop-change.bat
31 reg_system_srv
32 remote_manager_system
33 remote_manager_system__copy_
34 remote_tool
35 rich_ad_system
36 rich_addvalue
37 rich_addvalue2
38 rich_backup
39 rich_bt2
40 rich_common_lib
41 rich_gpxe
42 rich_manager
43 rich_manager_cp
44 rich_netclone2
45 rich_ntfs_lib
46 rich_octopus
47 rich_octopus3
48 rich_octopus3x
49 rich_protect
50 rich_register
51 rich_rms
52 rich_servercontrol
53 rich_test_docs
54 richcgo
55 richdlxp  #2.0 µÄ°æ±¾.
56 richdlxp_cp
57 richgau10
58 rt_gameupdate_bt
59 stock_info
60 super_cgo
61 svn-auth-file
62 training
63 virtual_desk_system
64 web_cs
65 web_daohang
66 web_gamemenu
67 web_office
68 web_register
69 web_richbar
70 web_richtech
71 ww_btupdate
72 ww_centmanager
73 ww_frameman
74 ww_gamemenu
75 ww_gamesync
76 ww_gmclient
77 ww_interface
78 ww_netclone
79 ww_netdisk
80 ww_secucenter

