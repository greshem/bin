#!/usr/bin/python
DATA="""
#==========================================================================
#赵中国的新的api的测试.
curl -L  -c cookie  -XPOST 192.168.82.173:33333/api/wzcloud/user/login -d ' { "username": "demo", "password": "demo" } '


#原版的
#demo用户
curl -L  -c cookie  -XPOST 192.168.82.173:33333/auth/login/ -d "username=demo&password=demo"
#admin用户
curl -L  -c cookie  -XPOST 192.168.82.173:33333/auth/login/ -d "username=admin&password=admin"


#调用api 的 一个例子
curl -L  -b cookie     192.168.82.173:33333/
curl -L  -b cookie     192.168.82.173:33333/api/wzcloud/nova/InstanceList/

"""
print DATA;


