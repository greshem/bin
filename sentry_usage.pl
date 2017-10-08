#!/usr/bin/perl
foreach (<DATA>)
{
    print $_;
}
__DATA__

用docker 反而很烦， 
#==========================================================================
1. 版本   django-1.6.1

2.  数据库配置  sqlite 的. 
2. django syncdb 
    #然后再迁移 
    #
    #3. django  
