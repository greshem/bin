#!/usr/bin/python
#coding: gbk
from mysql_db  import  get_mysql_session;
session=get_mysql_session("keystone");

#��������֤ һ��������ȷ�ķ�ʽ: 
#1.  check_passwd  ����ֵ  ָ��д�� True
#2.  �����е� keystone user ������� passwd �޸ĳ�   hash ֵ . 

rows= session.execute("select user.name as user_name,user.password as user_passwd,project.name as tenant_name  from   user   left join  project  ON  project.id=user.default_project_id ;").fetchall();

for each in  rows:
    #print each['user_name'];
    url="""
    curl -s -X POST http://localhost:35357/v2.0/tokens \
    -d '{"auth": {"passwordCredentials": {"username":"%s", "password":"password"}, "tenantName":"%s"}}'  -H "Content-type: application/json"  |jq -r .access.token.id
""" %(each['user_name'], each['tenant_name']);
    print url;
    

