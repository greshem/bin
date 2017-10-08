#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

show dbs; #获取所有的数据库
use zhihu; #使用 知乎的数据库
db.question.find() #获取当前 数据库的 所有的数据
db.software.findOne() #
show collections：显示当前数据库中的集合（类似关系数据库中的表）#show tables;

#==========================================================================
mongoexport  --host  127.0.0.1 -db  teresa  -c wget  >  wget.json
mongoexport  --host  127.0.0.1 -db  teresa  -c wget -f domain,url >  wget.json

#
mongoimport --upsert  --host  127.0.0.1 -db  teresa -c  html3  < wget.json

#date 
mongoexport -h 192.168.1.50 -d zhihu -c html -o zhihu_50_day_16_19 -q '{update_time:{$lte:ISODate("2015-12-20T00:00:00.000Z"),$gte:ISODate("2015-12-16T00:00:00.000Z")}}'

