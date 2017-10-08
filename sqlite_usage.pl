#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
cd /root/bin_ext/sqlite-web/
python sqlite_web/sqlite_web.py  --host 0.0.0.0  --port  44444 /root/owncloud.db  


#--------------------------------------------------------------------------
#2011_02_28_16:34:44   星期一   add by greshem
#开始装入数据库
db=$(find /var/cache/yum/ |grep sqlite)
for each in $db
do
echo sqlite3 $each
done

#显示所有的数据库.
.database 

#显示所有的表
.tables
#dump 某个表.
.dump 

#导出到 cvs 文本. 
.output "output.cvs"

#显示表结构
.schema packages  dump 出来的是 表的创建的SQL的脚本， 需要转换一下 

#载入一个 sql 文件 , 在f13 16 上  jabberd 默认用sqlite 作为密码库 这里就用上了.
.read  /usr/share/jabberd/db-setup.sqlite

#search keyword containts sqlite 
#select  summary from packages where summary like '%sqlite%';

#gui tools
 sqliteman 
#==========================================================================
#svn repo root sqlit3   wc.db 的修改   select update 

.tables
.schema repository
select root from repository
update  repository set  root="http://acer/svn/diskless_rich/zjl/" where id=1;
select * from repository;

########################################################################
#mac list all download files 
1. sqlite3  ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'select LSQuarantineDataURLString from LSQuarantineEvent' |more 
