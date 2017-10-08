#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__


########################################################################

精通Windows Server2008命令行与PowerShell
I S B N：9787113101886
出 版 社：中国铁道
作    者：韩小琴 1kg
出版日期：2009-09-01
原    价：75.00
内容简介:
        本书全面地介绍了Windows Server 2008命令行、PowerShell和脚本的使用，包括文件和文件夹的管理、磁盘管理、系统管理、活动目录管理、网络管理、网络服务管理、系统诊断、故障恢复、系统安全、批处理和配置文件，PowerShell等一系列的命令行管理方式以及脚本。本书侧重于系统、服务、网络和安全管理应用，不仅介绍了各个命令的语法和参数，还列举了大量实例，能够迅速提高读者的动手能力和技术水平。
    本书适合于从事系统管理和网络管理的专业人员，同时适合于计算机及相关专业的学生，也可作为计算机培训学校的教材。

图书目录:

第1章  文件和文件夹管理 1
1.1  文件管理 1
1.1.1  append——指定打开文件 1
1.1.2  assoc——文件名扩展关联 2
1.1.3  attrib——文件属性 4
1.1.4  cipher——文件加密 5
1.1.5  comp——文件比较 10
1.1.6  copy——文件复制 11
1.1.7  robocopy——Windows的可靠文件复制 13
1.1.8  del——删除文件 22
1.1.9  expand——解压缩文件 23
1.1.10  compact——压缩文件 24
1.1.11  fc——文件比较 25
1.1.12  find——查找 27
1.1.13  findstr——搜索文本 28
1.1.14  ftype——文件类型 30
1.1.15  move——移动文件 31
1.1.16  rename（ren）——文件重命名 33
1.1.17  replace——替换文件 34
1.2  文件夹管理 36
1.2.1  chdir（cd）——改变目录 36
1.2.2  dir——列出文件目录 38
1.2.3  mkdir（md）——新建目录 40
1.2.4  rmdir（rd）——删除文件夹 41
1.2.5  tree——目录结构 43
1.2.6  type——浏览文本 44
1.2.7  verify——校验 45
1.2.8  verifier——驱动程序检验 46
1.2.9  where——位置 47
第2章  磁盘管理 49
2.1  磁盘分区与格式化 49
2.1.1  硬盘分区 49
2.1.2  磁盘格式化 51
2.1.3  Windows Server 2008系统分区 52
2.1.4  format——磁盘格式化 53
2.1.5  chkntfs——NTFS分区检查 55
2.1.6  convert——分区系统类型转换 57
2.1.7  fsutil——文件系统管理 58
2.2  磁盘优化 69
2.2.1  chkdsk——磁盘检查 69
2.2.2  defrag——磁盘碎片整理 71
2.2.3  compact——NTFS压缩 73
2.3  磁盘管理与卷标管理 74
2.3.1  diskprt——磁盘和分区管理 75
2.3.2  diskcopy——磁盘复制 79
2.3.3  diskcomp——磁盘比较 80
2.3.4  vssadmin——查看卷影副本 81
2.3.5  subst——虚拟驱动器 84
2.3.6  label——创建、修改或删除驱动器的卷标 86
2.3.7  vol——卷标 87
2.3.8  mountvol——设置装入点 87
第3章  系统管理 89
3.1  屏幕显示设置 89
3.1.1  chcp——活动控制台代码页 89
3.1.2  cls——清屏 90
3.1.3  color——屏幕色彩 91
3.1.4  prompt——提示符 92
3.1.5  title——命令行窗口标题 94
3.2  系统基本配置 94
3.2.1  country——国家设置 94
3.2.2  date——系统日期 97
3.2.3  time——系统时间 98
3.2.4  w32tm——时间服务 98
3.2.5  cmd——命令行 101
3.2.6  doskey——命令行宏 102
3.2.7  exit——退出命令行 103
3.3  显示系统信息 103
3.3.1  driverquery——查看设备驱动程序 103
3.3.2  help——帮助 105
3.3.3  systeminfo——系统信息 105
3.3.4  ver——系统版本 106
3.4  系统配置管理 107
3.4.1  mem——显示内存分配 107
3.4.2  msiexec——Windows Installer服务 108
3.4.3  debug——调试 113
3.4.4  graftabl——启用扩展字符集 119
3.4.5  mode——系统设置 121
3.4.6  path——路径 125
3.4.7  reg——修改注册表子项 125
3.4.8  regedit——注册表编辑器 132
3.4.9  regsvr32——将dll文件注册为命令 132
3.4.10  schtasks——任务计划 132
3.5  任务管理 145
3.5.1  shutdown——关闭或重启计算机 145
3.5.2  start——运行 146
3.5.3  tapicfg——TAPI应用程序目录分区 147
3.5.4  taskkill——结束任务进程 149
3.5.5  tasklist——显示任务进程 151
3.6  存储的用户名和密码 153
第4章  活动目录管理 155
4.1  域控制器的管理 155
4.1.1  adprep——域控制器准备工具 155
4.1.2  dcpromo——活动目录向导 158
4.2  活动目录对象的管理 159
4.2.1  dsquery——查找对象 159
4.2.2  dsget——显示对象 173
4.2.3  dsadd——添加对象 186
4.2.4  dsmod——修改对象 193
4.2.5  dsmove——移动对象 203
4.3  组策略的管理 204
4.3.1  gpresult——查看组策略 204
4.3.2  gpupdate——刷新组策略 206
4.3.3  ntdsutil——活动目录管理工具 207
第5章  网络管理 210
5.1  网络测试工具 210
5.1.1  ping——IP连接测试 210
5.1.2  ipconfig——IP配置信息 213
5.1.3  arp——地址解析 215
5.1.4  route——路由 216
5.1.5  netstat——网络统计信息 217
5.2  网络登录与管理 219
5.2.1  hostname——主机名 219
5.2.2  rasdial——自动建立连接 220
5.2.3  telnet——远程管理 221
5.2.4  tlntadmn——远程管理Telnet Server 222
5.2.5  tracerpt——设置跟踪程序 224
5.2.6  tracert——路由追踪 225
5.2.7  tftp——日常文件传输协议 226
5.2.8  getmac——查看网卡MAC地址 227
5.2.9  nbtstat——NetBIOS统计数据 228
5.3  网络配置命令 230
5.3.1  set address——配置IP地址 230
5.3.2  add address——添加IP地址 231
5.3.3  delete address——删除IP地址 232
5.3.4  show address——查看IP地址 232
5.3.5  add dnsserver——添加DNS服务器 233
5.3.6  delete dnsserver——删除DNS 234
5.3.7  show dnsserver——查看DNS 234
5.3.8  set winsserver——设置WINS 234
5.3.9  add winsserver——添加WINS 235
5.3.10  delete winsserver——删除WINS 235
5.3.11  show winsserver——查看WINS 235
5.3.12  show icmpstats——查看ICMP 236
5.3.13  show interface——查看网络接口统计 236
5.3.14  show ipaddress——查看IP地址信息 237
5.3.15  show ipnettomedia——查看ARP缓存 238
5.3.16  show ipstats——查看IP统计 238
5.3.17  show joins——查看加入的IP多播组 238
5.3.18  show tcpconn——查看TCP连接信息 239
5.3.19  show tcpstats——显示TCP统计 239
5.3.20  show udpconn——查看UDP端口信息 240
5.3.21  show udpstats——显示UDP统计 240
5.3.22  show config——显示网络接口配置 241
5.3.23  show offload——查看任务 241
5.3.24  delete arpcache——删除ARP缓存 241
5.3.25  从命令提示符运行netsh命令 241
5.3.26  从netsh.exe命令提示符运行netsh 243
第6章  网络服务管理 249
6.1  网络服务 249
6.1.1  mmc——管理控制台 249
6.1.2  net——网络服务管理 250
6.1.3  runas——作为其他用户运行 272
6.1.4  sc——服务控制 274
6.1.5  waitfor——同步计算机 287
6.2  DHCP服务 288
6.2.1  netsh dhcp 288
6.2.2  netsh dhcp server——配置DHCP服务 290
6.2.3  netsh dhcp server scope——配置DHCP作用域 301
6.2.4  netsh dhcp server mscope——DHCP多播域 305
6.3  DNS服务——nslookup 305
6.4  文件服务 308
6.4.1  cacls——设置ACL 308
6.4.2  openfiles——打开共享文件 310
6.4.3  pushd——存储当前目录 313
6.4.4  takeown——成为文件所有者 314
6.5  证书服务——Certre9 315
6.6  终端服务 318
6.6.1  change——终端服务更改 318
6.6.2  cmstp——“连接管理器”服务配置 319
6.6.3  finger——查看登录用户信息 320
6.6.4  query——终端服务查询 320
6.6.5  reset session——重置会话 323
第7章  系统诊断 324
7.1  relog——导出性能日志文件 324
7.2  typeperf——性能计数器 325
7.3  unlodctr——删除计数器 326
7.4  eventcreate——自定义事件 327
7.5  netsh子命令——netsh诊断命令 328
7.5.1  connect ieproxy——代理服务器连接 328
7.5.2  connect iphost——到远程主机的连接 329
7.5.3  connect mail——到OE服务器的连接 329
7.5.4  connect news——设置OE新闻服务器TCP/IP连接 329
7.5.5  dump——创建脚本 329
7.5.6  gui——启动诊断工具 329
7.5.7  ping adapter——验证与其他设备的连接 330
7.5.8  ping dhcp——验证与DHCP服务器的连接 330
7.5.9  ping dns——验证与DNS服务器的连接 331
7.5.10  ping gateway——验证与默认网关的连接 331
7.5.11  ping ip——验证与指定IP的连接 332
7.5.12  ping iphost——验证与远程或本地主机的连接 332
7.5.13  ping loopback——验证与环回地址的连接 332
7.5.14  ping mail——验证与邮件服务器的连接 332
7.5.15  ping news——验证与OE新闻服务器的连接 333
7.5.16  ping wins——验证与WINS服务器的连接 333
7.5.17  show adapter——显示网卡信息 333
7.5.18  show all——显示所有网络对象 334
7.5.19  show client——显示所有网络客户 334
7.5.20  show computer——显示管理接口 335
7.5.21  show dhcp——显示DHCP服务器 335
7.5.22  show dns——显示DNS服务器 336
7.5.23  show gateway——显示默认网关 336
7.5.24  show ieproxy——显示IE代理服务器 337
7.5.25  show ip——显示网卡IP地址信息 337
7.5.26  show mail——显示邮件服务器 338
7.5.27  show modem——显示调制解调器信息 338
7.5.28  show news——显示新闻服务器的配置信息 339
7.5.29  show os——显示操作系统信息 339
7.5.30  show test——显示对象的连接 339
7.5.31  show version——显示操作系统版本 340
7.5.32  show wins——查看WINS服务器 340
7.6  eventvwr——Windows 事件查看器 341
7.7  wevtutil——管理Windows事件 343
第8章  故障恢复 349
8.1  bcdedit——配置数据存储编辑器 349
8.1.1  bcdedit命令简介 349
8.1.2  应用于存储的bcdedit命令选项 349
8.1.3  应用于存储项的bcdedit命令选项 351
8.1.4  应用于项目操作的bcdedit命令选项 355
8.1.5  控制输出的bcdedit命令选项 357
8.1.6  控制启动管理器的bcdedit命令选项 360
8.1.7  控制紧急管理服务的bcdedit命令选项 363
8.1.8  控制调试的bcdedit命令选项 365
8.2  系统文件的备份与恢复 368
8.2.1  安装备份工具 368
8.2.2  备份系统状态 369
8.2.3  恢复系统状态 370
8.3  pathping——显示丢失信息 371
8.4  recover——数据恢复 373
8.5  efc——扫描受保护的系统文件 374
第9章  系统安全 376
9.1  Internet协议安全 376
9.1.1  add filter——添加筛选器到指定的筛选器列表 376
9.1.2  add filteraction——创建具有安全措施的筛选器操作 378
9.1.3  add filterlist——创建指定名称的空筛选器列表 379
9.1.4  add policy——创建IPSec策略 379
9.1.5  add rule——创建规则 380
9.1.6  delete all——删除所有IPSec策略、筛选器列表和筛选器操作 382
9.1.7  delete filter——删除筛选器 382
9.1.8  delete filteraction——删除筛选器操作 383
9.1.9  delete filterlist——删除筛选器列表 383
9.1.10  delete policy——删除IPSec 策略及所有关联规则 383
9.1.11  delete rule——删除规则 384
9.1.12  exportpolicy——导出IPSec策略信息 384
9.1.13  importpolicy——导入IPSec策略信息 385
9.1.14  set defaultrule——修改策略的默认响应规则 385
9.1.15  set filteraction——修改筛选器操作 386
9.1.16  set filterlist——修改筛选器列表 387
9.1.17  set policy——修改 IPSec 策略 388
9.1.18  set store——设置当前IPSec策略的存储位置 389
9.1.19  set batch——设置批更新模式 389
9.1.20  set rule——更改规则 390
9.1.21  show all——显示所有IPSec策略配置信息 391
9.1.22  show filteraction——显示筛选器操作的配置信息 392
9.1.23  show filterlist——显示筛选器列表 393
9.1.24  show policy——显示IPSec 策略配置信息 393
9.1.25  show gpoassignedpolicy——显示组分配策略的详细信息 394
9.1.26  show rule——显示规则的详细信息 395
9.1.27  show store——显示当前策略存储类型 396
9.1.28  add mmpolicy——将主模式策略添加到SPD 396
9.1.29  add qmpolicy——将快速模式策略添加到SPD 397
9.1.30  add rule——添加一个规则和相关联的筛选器到SPD 398
9.1.31  delete all——从SPD中删除所有策略 400
9.1.32  delete mmpolicy——SPD中删除主模式策略 400
9.1.33  delete qmpolicy——从SPD中删除快速模式策略 401
9.1.34  delete rule——从SPD中删除规则及与其相关联的筛选器 401
9.1.35  set config——设置IPSEC配置和启动时间行为 402
9.1.36  set mmpolicy——更改SPD中的主模式策略 404
9.1.37  set qmpolicy——更改SPD中的快速模式策略 405
9.1.38  set rule——修改SPD中的规则和相关联的筛选器 406
9.1.39  show config——显示IPsec配置 407
9.1.40  show all——显示SPD中所有IPSec策略及筛选器 408
9.1.41  show mmfilter——从SPD中显示主模式筛选器详细信息 409
9.1.42  show mmpolicy——从SPD中显示主模式策略详细信息 409
9.1.43  show mmsas——显示SPD中主模式安全关联 410
9.1.44  show qmfilter——从SPD中显示快速模式筛选器详细信息 411
9.1.45  show qmpolicy——从SPD中显示快速模式策略详细信息 412
9.1.46  show qmsas——从SPD中显示快速模式安全关联 412
9.1.47  show rule——显示SPD中的规则详细信息 413
9.1.48  show stats——从 SPD 中显示IPsec和IKE统计信息 414
9.2  ipxroute——IPX路由 414
9.3  lodctr——性能计数 415
9.4  logman——管理日志 417
9.5  secedit——安全配置 422
9.5.1  secedit /analyze 422
9.5.2  secedit /configure 424
9.5.3  secedit /export 425
9.5.4  secedit /import 426
9.5.5  secedit /validate 427
9.5.6  secedit /generaterollback 427
9.6  组策略管理工具 428
9.6.1  gpoTool——检查域控制器上组策略对象 428
9.6.2  gpresult——组策略结果检测工具 431
9.6.3  gpupdate——组策略刷新工具 434
第10章  批处理和配置文件 436
10.1  批处理命令 436
10.1.1  break——检查Crtl+C 436
10.1.2  call——调用子批处理 437
10.1.3  for——执行特定命令 438
10.1.4  goto——批处理定向 440
10.1.5  If——批处理条件 440
10.1.6  echo——回显 442
10.1.7  rem——注释 443
10.1.8  pause——暂停 443
10.1.9  start——运行 444
10.1.10  choice命令 445
10.1.11  shift——更改参数的位置 447
10.2  系统配置文件 448
10.2.1  buffers——磁盘缓冲区 448
10.2.2  device——将驱动程序加载到内存 449
10.2.3  devicehigh——加载驱动程序到高内存区 449
10.2.4  echoconfig——显示消息 449
10.2.5  endlocal——本地化操作 450
10.2.6  set——设置环境变量 450
10.2.7  setlocal——环境变量的本地化 452
10.3  管道和重定向 454
10.3.1  重定向操作符 454
10.3.2  ——管道操作符 457
10.3.3  at——制定计划 458
10.3.4  edit——文本编辑器 461
10.3.5  more——单屏输出 463
10.3.6  sort——排序 466
10.3.7  find——查找 469
10.4  其他批处理符号 471
10.4.1  @——隐藏本行内容 471
10.4.2  ^——前导字符 472
10.4.3  &——同一行中使用多个不同命令 472
10.4.4  &&——如果多个命令中的一个失败即中止后续命令 473
10.4.5  ]sysy[ ]sysy[——允许在字符串中包含空格 473
10.4.6  ,——代替空格 474
10.4.7  ;——隔开同一命令的不同目标 475
10.5  通配符 475
10.5.1  *——通配符命令 475
10.5.2  ?——通配符命令 476
第11章  PowerShell管理 477
11.1  认识PowerShell 477
11.1.1  功能简介 477
11.1.2  PowerShell不同语言版本 478
11.1.3  Windows PowerShell命名系统 478
11.1.4  策略执行 480
11.1.5  脚本扩展文件名 480
11.1.6  PowerShell管道 480
11.1.7  PowerShell命令输出 481
11.2  安装并运行PowerShell 481
11.2.1  安装PowerShell 482
11.2.2  运行PowerShell 482
11.3  使用PowerShell帮助系统 483
11.3.1  get-help 484
11.3.2  get-command 488
11.4  WMI对象获取 490
11.4.1  显示WMI类列表 490
11.4.2  WMI类详细信息显示 492
11.5  计算机信息收集 493
11.5.1  了解可用磁盘空间 493
11.5.2  BIOS信息收集 494
11.5.3  处理器信息展示 494
11.5.4  制造商及型号了解 495
11.5.5  桌面设置收集 495
11.5.6  操作系统版本信息查询 496
11.5.7  已安装补丁程序展示 496
11.5.8  本地用户和所有者信息查询 497
11.5.9  登录会话信息展示 497
11.5.10  登录用户信息获取 497
11.5.11  服务状态查询 498
11.6  利用PowerShell实现本地进程管理 499
11.6.1  get-process 499
11.6.2  stop-process 501
11.6.3  停止所有其他Windows PowerShell会话 503
11.7  利用PowerShell实现网络任务执行 504
11.7.1  执行Ping操作 504
11.7.2  查询IP地址 505
11.7.3  罗列IP配置数据 505
11.7.4  网络适配器属性检查 506
11.7.5  网络共享实现 506
11.7.6  网络共享删除 506
11.7.7  可访问的网络驱动器连接 507
11.8  利用PowerShell实现软件操作 507
11.8.1  应用程序安装 507
11.8.2  应用程序卸载 508
11.8.3  Windows Installer应用程序查询 508
11.8.4  可卸载应用程序总列 509
11.8.5  Windows Installer应用程序升级 510
11.9  活用PowerShell Plus 510
第12章  脚本 512
12.1  脚本概述 512
12.1.1  什么是Windows脚本 512
12.1.2  Windows脚本架构 512
12.1.3  脚本编辑工具 513
12.1.4  运行Windows脚本 517
12.2  管理活动目录 519
12.2.1  管理计算机账户 519
12.2.2  管理组织单位 520
12.2.3  管理组 522
12.2.4  管理域 523
12.2.5  管理域账户 526
12.3  计算机管理 529
12.3.1 管理系统还原点 529
12.3.2  开始菜单设置 530
12.3.3  屏幕保护设置 532
12.3.4  任务栏设置 533
12.3.5  资源管理器设置 534



#2011_01_10_15:39:12 add by greshem
#1. netcat nc # 
2. nmapwin 
3. ethereal 提供的命令行工具.  
capinfos.exe: 
dumpcap.exe: 	
editcap.exe: 	
mergecap.exe: 	
rawshark.exe: 	
text2pcap.exe: 	
tshark.exe: 	
#2011_01_10_14:02:02 add by greshem

windows2003 新增加的命令。 
	assoc  文件关联工具. 
	adprep。对Windows 2000域和林进行准备，以便升级到Windows Server 2003 Standard Edition、Windows Server 2003 Enterprise Edition 或 Windows Server 2003 Datacenter Ed1t1On。
    bootcfg。配置、查询或更改Boot.imi文件设置。
    choice。在批处理程序中，通过显示提示信息并暂停批处理程序，用户可以从一组用户选项键中进行选择。
    clip。从命令行将命令输出重定向到 "剪贴板"。
    cmdkey。创建。列出和删除存储用户名和密码或凭据。
    defrag。定位并整理本地卷上的零碎启动文件、数据文件和文件夹。
    diSKpart。管理磁盘、分区或卷。
    driverquery。查询驱动程序和驱动程序属性列表。
    dsadd。将计算机、联系人。组、组织单位或用户添加到目录P。
    dsget。显示目录中计算机、联系人、组、组织单位、服务器或用户的选定属性。
    dsmod。修改目录中的现有用户、计算机、联系人、组或组织单位。
    dsmove。将任何对象从目录中的当前位置移动到新位置（只要移动可以在单个域控制器内进行），并且重命名对象而不在目录树中移动它。
    dsquery。使用指定的搜索条件在目录中查询并查找计算机、组、组织单位、服务器或用户列表。
    dsrm。从目录中删除某种特定类型的对象或任何常规对象。
    eventcreate。使管理员能够在指定事件日志中创建自定义事件。
    eventquery。列出一个或多个事件日志中的事件和事件属性。
    eventtriggers。显示和配置本地或远程计算机上的事件触发器。
    expand。展开一个或多个压缩文件。
    forfiles。从文件夹或树中为批处理选择文件。
    freedisk。在继续安装进程之前检查可用的磁盘空间。
    fsutil。管理重分析点，从而管理稀疏文件、卸载卷或扩展卷。
    getmac。获得媒体访问控制（MAC）地址和网络协议列表。
    gettype。将系统环境变量 %ERRORLEVEL% 设置为与指定的Windows操作系统相关的值。
    gpresult。显示用户或计算机的组策略设置和策略的结果集（RSoP）。
    helpctr。启动帮助和支持中心。
    iisapp。报告服务于某个特定应用程序池当前正在运行W3pwp.exe进程的进程标识符（PID）。
    iisback。创建并管理远程或本地计算机的Internet信息服务（IIS）配置（配置数据库和架构）的备份副本。
    iiscnfg。导入和导出本地或远程计算机上所有或选定部分的Intemet信息服务（IIS）配置。
    iisext。配置并管理运行带有（Internet信息服务IIS）6.0 的Windows Server 2003服务器上的Web服务扩展、应用程序和单独的文件。
    iisftp。在运行Internet信息服务器（IIS）6.O 的服务器上创建、删除和列出FTP站点。也可以启动、停止、暂停和继续FTP站点。
    iisftpdr。在运行Internet信息服务器（IIS）6.O 的服务器上创建和删除FTP站点的虚拟目录。
    iisvdir。在运行Internet信息服务器（IIS）6.O 的服务器上创建和删除网站的虚拟目录。
    iisweb。在运行Internet信息服务器（IIS）6.O 的服务器上创建、删除和列出网站。也可以启动、停止和暂停和继续网站。
    inuse。替换已锁定的操作系统文件。
    logman。在本地和远程系统上，管理和调度性能计数器和事件跟踪日志集合。
    nlb。替代Wlbs.exe以管理和控制网络负载平衡操作。
    nlbmgr。从一台计算机配置和管理网络负载平衡群集和所有群集主机。
    openfiles。查询。显示或中断打开的文件。
    pagefileconfig。显示和配置系统的页面文件虚拟内存设置。
    perfmon。允许打开由来自Windows NT 4.0 版本的“性能监视器”的设置文件配置的“性能”控制台。
    prncnfg。配置或显示有关打印机的信息。
    prndrvr。从本地或从远程打印服务器上添加。删除和列出打印机驱动程序。
    prnjobs。暂停、继续、取消和列出打印作业。
    prnmngr。添加、删除和列出打印机或打印机连接，此外还可以设置和显示默认打印机。
    prnport。创建、删除和列出标准的TC皿P打印机端口，此外还可以显示和更改端口配置。
    pmqctl。打印测试页，暂停或继续打印机，清除打印机队列。
    relog。将性能计数器从性能计数器日志申提出并转为其他格式，例如，text-TSV（用于制表符分隔的文本）、text-CSV（用于逗号分隔的文本）、binary-BIN或SQL。
    rss。启用“远程存储”，它用于扩展服务器磁盘空间。
    sc。检索和设置服务信息。测试和调试服务程序。
    schtasks。安排命令和程序，使其定期运行或在指定时间运行。向计划申添加和从中删除任务、根据需要启动和停止任务以及显示和更改计划任务。
    setx。在本地或系统环境中设置环境变量，无需编写程序或制作脚本。
    shutdown。关闭或重新启动本地或远程计算机。
    systeminfo。查询系统以获取基本系统配置信息。
    takeown。通过使管理员成为文件的所有者，允许管理员恢复过去被拒绝的文件访问权限。
    taskkill。结束一个或多个任务或进程。
    tasklist。显示当前运行在本地或远程计算机上的应用程序、服务以及进程ID（PID）的列表。
    timeout。暂停命令处理器指定的秒数。
    tracerpt。处理事件跟踪日志或已安装的事件跟踪提供程序的实时数据，并允许为已发生事件生成跟踪分析报告和CSV（逗号分隔）文件。
    tsecimp。将指派信息从可扩展标记语言 （XML）文件导入 TAPI 服务器安全文件（TTsec.ini）中。
    typeperf。将性能计数器数据写到命令窗口或受支持的日志文件格式中。
    shoamix。使用信号同步一个网络上的多台计算机。
    shoamix。定位并显示与给定参数相匹配的所有文件。
    shoami。为当前登录的用户返回域名、计算机名、用户名、组名、登录标识符和特权。
    WMIC。更方便地使用Windows Management Instrumentation（WMI）和通过WMI来管理的系统。 

#ddk 2005
########################################################################
#有文档的windows 的命令行工具. 
http://technet.microsoft.com/zh-cn/552ed70a-208d-48c4-8da8-2e27b530eac7%28l=WS.10%29
binplace.exe # 批量生成 PDB 符号信息文件。 
popd # linux 的popd 一样.
mem.exe # /proc/meminfo free
pushd # linux pushd 一样. 
build.exe
cl.exe
cvtres.exe
fusionmanifestvalidator.exe
lib.exe
link.exe
makedirs.exe
mapsym.exe
mc.exe
midl.exe
midlc.exe
mkcdir.exe
ml.exe
mofcomp.exe
nmake.exe
preprocessor.exe
rc.exe
tracewpp.exe
wmimofck.exe

#2011_01_07_17:13:07 add by greshem
########################################################################
#windbg
agestore.exe
breakin.exe
cdb.exe
convertstore.exe
dbgrpc.exe
dbh.exe
dumpchk.exe
dumpexam.exe
gflags.exe
i386kd.exe
ia64kd.exe
kd.exe
kdbgctrl.exe
kill.exe
list.exe 
pdbcopy.exe
rtlist.exe
symchk.exe
symstore.exe
tlist.exe
umdh.exe
vmdemux.exe

cdimage.exe # mkisosfs  cdImage.exe
########################################################################
vss 版本控制. 
betest.exe: 
vshadow.exe: 
vssagent.exe: 
vstorcontrol.exe: 
vswriter.exe: 
########################################################################
1. snort.exe 

########################################################################
# SDK 自带的问题. C:\Program Files\Microsoft SDKs\Windows\v6.0A\bin
AxImp.exe
Cert2Spc.exe
Consume.exe
CorFlags.exe
Mdbg.exe
MsiCert.exe
PEVerify.exe
PermCalc.exe
ResGen.exe
SecUtil.exe
SetReg.exe
SoapSuds.exe
SqlMetal.exe
StoreAdm.exe
SvcUtil.exe
TlbExp.exe
TlbImp.exe
WCA.exe
WFC.exe
al.exe
apatch.exe
aspnet_merge.exe
checkv4.exe
clrver.exe
cordbg.exe
ctrpp.exe
disco.exe
gacutil.exe
genmanifest.exe
ildasm.exe
isXPS.exe
lc.exe
mage.exe
make-shell.exe
makecert.exe
mgmtclassgen.exe
midl.exe
midlc.exe
mt.exe
perflibmig.exe
ptconform.exe
pvk2pfx.exe
sgen.exe
signtool.exe
sn.exe
tracefmt.exe
tracepdb.exe
tracewpp.exe
validatesd.exe
windows_subsystem.exe
wsdl.exe
xsd.exe
xsltc.exe

#2011_01_07_15:48:53 add by greshem
1. pecmd 
2. win7 里面的新增加的命令. 
3. VC6 vc6 vc8 vc9 vc10  开发工具里面的命令. msdev
4. cygwin 里面的命令， 但是深度不够. 
5. perl win32 里面的命令. 
6. 自己开发的windows  的命令行工具， 按照流程进行提交. 
7. gnuwin32. 
8. gcc win32 里面的 
9.  services.exe --list #  chkconfig --list
10.   tlist.exe  #ps -le 进程.  
11 msdev make #dsp  autobuild 自动编译.  
12 rar zip  压缩. 
13.ddk 里面的工具, 里面的命令行.   
14. wine 里面的命令, 有代码的都可以弄成， 命令的. 
15. reactos 里的命令. 
16. mplayer ffmpeg.exe 
17. 视屏 rar 的命令行. 
18. 7zip. 
19. slimftpd # ftpd 服务器. 
20. svn.exe  
########################################################################
#vc6 编译命令. 
bscmake.exe
cl.exe ; 编译.  compile
cvpack.exe
cvtres.exe
dumpbin.exe
editbin.exe
lib.exe;  静态库. 
link.exe ; 链接. 
mapsym.exe
mc.exe
midl.exe
mktyplib.exe
nmake.exe ; make 工具. 
plist.exe ; profile; gperf; 
prep.exe
profile.exe
rebase.exe # 把exe 里面的调试信息， 剥离到单独一个.dbg 文件coff 格式的. strip.
########################################################################
hhc.exe # chm 制作. 

########################################################################
aoe.exe 
systeminfo.exe  #hotfix 
arp.exe 
at.exe 
atmadm.exe  # 
attrib.exe	#fs 文件属性.  
auditusr.exe 
bootcfg.exe 
bootok.exe  #
bootvrfy.exe 
devcon.exe #ioctl 
cacls.exe  #acl
chkdsk.exe 
chkntfs.exe 
cidaemon.exe  #
cipher.exe  #ntfs  加密文件， crypt
cmd.exe 
comp.exe # diff cmp 
compact.exe  #压缩.
convert.exe  #ntfs vfat 
cscript.exe	 #脚本.  
defrag.exe	 
diantz.exe	#makecab 压缩.  
diskpart.exe  # fdisk 
diskperf.exe 
doskey.exe #命令行.
driverquery.exe #  lsmod , 加载的模块的查询. 
msiexec.exe
forfiles # windows2003 程序 xp 没有. find  
winmsd.exe 
esentutl.exe 
eventcreate.exe 
eventtriggers.exe 
expand.exe  # zip cab 
fc.exe  # cmp diff 
find.exe 
findstr.exe 
finger.exe 
fltMc.exe  #filter 驱动 加载. 
forcedos.exe  #
fsutil.exe ;  #filesystem 文件系统.
ftp.exe ; lftp 
getmac.exe  # mac地址  ifconfig  
gpresult.exe 
gpupdate.exe 
hostname.exe 
ipconfig.exe 
ipsec6.exe 
ipv6.exe 
ipxroute.exe 
java.exe 
jview.exe # 
label.exe # 硬盘的卷标. 
locator.exe #
lodctr.exe 
logman.exe  #日志 回话
logoff.exe 
lpq.exe 
lpr.exe 
makecab.exe  #cab 压缩. 
mmcperf.exe 
mountvol.exe 
mqbkup.exe 
mqsvc.exe 
mqtgsvc.exe 
mrinfo.exe 
msg.exe 
nbtstat.exe 
net.exe 
net1.exe 
netsh.exe  # ifconfig iptraf
netstat.exe 
nslookup.exe 
ntvdm.exe 
nutcsrv4.exe 
nwscript.exe 
openfiles.exe 
pathping.exe 
pentnt.exe 
ping.exe 
ping6.exe 
powercfg.exe  # 电源模式.
print.exe 
proxycfg.exe 
qappsrv.exe 
qprocess.exe 
qwinsta.exe 
rasautou.exe 
rasdial.exe 
rcp.exe 
recover.exe 
reg.exe 
regini.exe 
relog.exe # 将性能计数器从性能计数器日志中提出并转为其他格式 
replace.exe 
reset.exe 
rexec.exe 
route.exe 
routemon.exe 
rsh.exe 
rsm.exe 
rsvp.exe 
runas.exe 
rwinsta.exe 
sc.exe  # services  控制. 
scardsvr.exe 
schtasks.exe 
secedit.exe 
sfc.exe #文件系统保护， check version, md5. 
shadow.exe  #监视 终端服务对话. 
shutdown.exe #reboot
smbinst.exe 
sort.exe 
spupdsvc.exe  
subst.exe  #link 路径和驱动器连接起来.  
taskkill.exe 
tree.exe # tree linux windows 都一样. 
tasklist.exe 
tcpsvcs.exe  #
telnet.exe 
tftp.exe 
tlntadmn.exe  #telnet 终端登陆. 
tlntsess.exe 
tracerpt.exe 
tracert.exe 
tracert6.exe 
tscon.exe 	#终端. 
tsdiscon.exe 
tskill.exe 
tsshutdn.exe 
tswpfwrp.exe 
typeperf.exe  #top 性能监视.  GUI 对应perfmon, 有10000多个监控用例.  sar 
tzchange.exe 
unlodctr.exe 
ups.exe 
verifier.exe 
vmnetdhcp.exe 
vssadmin.exe 
w32tm.exe 
wdfmgr.exe  #
xcopy.exe 
################
#SysinternalsSuite-20100926, tools 
./accesschk.exe
./adrestore.exe
./autorunsc.exe
./Clockres.exe 
./Contig.exe # 文件连续. 
./Coreinfo.exe # /proc/cpuinfo
./ctrl2cap.exe #
./diskext.exe #
./du.exe 	#du 
./efsdump.exe
./handle.exe  # 和lsof 工具相仿
./hex2dec.exe
./junction.exe
./Listdlls.exe #dll so dll  #### lsof |grep so$ 
./ldmdump.exe
./livekd.exe 符号信息， 符号服务器
./logonsessions.exe # who last 
./movefile.exe
./ntfsinfo.exe #n
./pendmoves.exe
./pipelist.exe #lsof 
./ProcFeatures.exe # cpuinfo
./psexec.exe #rexec ssh 
./psfile.exe #
./psgetsid.exe
./Psinfo.exe #
./pskill.exe #kill 
./pslist.exe #ps -el 
./psloggedon.exe
./psloglist.exe # eventlog 日志. 
./pspasswd.exe
./psservice.exe #  chkconfig --list
./psshutdown.exe
./pssuspend.exe
./RegDelNull.exe # 注册表.  
./regjump.exe #注册表 跳转. 
./sdelete.exe
./sigcheck.exe
./streams.exe
./strings.exe
./sync.exe #sync 
./Tcpvcon.exe #lsof 
./Volumeid.exe
./whois.exe
