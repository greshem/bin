#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
[MESSAGE]
count=17
1=0|1234567||12:00|日志 日记.|
2=0|0234560||20:30|考勤 忘记打卡|
3=0|1234567||11:25|中午吃饭.|
4=0|0000500||15:23|海贼王|
5=0|0000060||13:24|工作小结|
6=0|0004060||09:25|手机充电|
7=1||2013-12-21|08:30|msn: 温淑娜生日2|
8=1||2012-12-21|17:44|温淑娜生日|
9=0|0234560||08:44|钱奕程: msn sara 日志|
10=0|0234560||21:12|考勤 忘记打卡|
11=0|0234560||22:13|考勤 忘记打卡|
12=0|0234560||21:59|仰卧起坐|
13=0|0004060||13:00|1. yum.log 备份, 2.移动硬盘同步到笔记  本  3. 备份 _pre_cache|
14=0|0000060||12:24|小芳 这个月发票|
15=0|0004060||11:52|下午 手机充电|
16=0|0234560||19:59|钱奕程 lashi, 温淑娜 仰卧起坐， 钱奕程作业.钱奕程唐诗|
17=0|0234560||23:40|晚上的作业: 下载, 拷贝 , 备份, qemu安装, bench, iozone, ltp , buildbot|


[SHUTDOWN]
LastShutTime=2013-01-29 12:34
[OPTION]
Beep=1

