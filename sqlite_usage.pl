#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
cd /root/bin_ext/sqlite-web/
python sqlite_web/sqlite_web.py  --host 0.0.0.0  --port  44444 /root/owncloud.db  


#--------------------------------------------------------------------------
#2011_02_28_16:34:44   ����һ   add by greshem
#��ʼװ�����ݿ�
db=$(find /var/cache/yum/ |grep sqlite)
for each in $db
do
echo sqlite3 $each
done

#��ʾ���е����ݿ�.
.database 

#��ʾ���еı�
.tables
#dump ĳ����.
.dump 

#������ cvs �ı�. 
.output "output.cvs"

#��ʾ��ṹ
.schema packages  dump �������� ��Ĵ�����SQL�Ľű��� ��Ҫת��һ�� 

#����һ�� sql �ļ� , ��f13 16 ��  jabberd Ĭ����sqlite ��Ϊ����� �����������.
.read  /usr/share/jabberd/db-setup.sqlite

#search keyword containts sqlite 
#select  summary from packages where summary like '%sqlite%';

#gui tools
 sqliteman 
#==========================================================================
#svn repo root sqlit3   wc.db ���޸�   select update 

.tables
.schema repository
select root from repository
update  repository set  root="http://acer/svn/diskless_rich/zjl/" where id=1;
select * from repository;

########################################################################
#mac list all download files 
1. sqlite3  ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'select LSQuarantineDataURLString from LSQuarantineEvent' |more 
