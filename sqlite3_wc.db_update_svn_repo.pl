#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
.tables
.schema repository
select root from repository
update  repository set  root="http://acer/svn/diskless_rich/zjl/" where id=1;
select * from repository;

########################################################################
#data 
1. 
sqlite> .tables
ACTUAL_NODE    NODES          PRISTINE       WC_LOCK      
EXTERNALS      NODES_BASE     REPOSITORY     WORK_QUEUE   
LOCK           NODES_CURRENT  WCROOT       

2. 
sqlite> .schema repository
CREATE TABLE REPOSITORY (   id INTEGER PRIMARY KEY AUTOINCREMENT,   root  TEXT UNIQUE NOT NULL,   uuid  TEXT NOT NULL   );
CREATE INDEX I_ROOT ON REPOSITORY (root);
CREATE INDEX I_UUID ON REPOSITORY (uuid);

3. 
sqlite> select root from repository
http://172.16.10.10/svn/diskless_rich_zjl
sqlite> select * from repository;
1|http://172.16.10.10/svn/diskless_rich_zjl|818dc9e4-f836-4d1c-aa25-3abce27fed71

4. 
sqlite> update  repository set  root="http://acer/svn/diskless_rich/zjl" where id=1;   #注意最后的路径不能有 / 
sqlite> select * from repository;
1|http://acer/svn/diskless_rich/zjl/|818dc9e4-f836-4d1c-aa25-3abce27fed71



