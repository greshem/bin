#!/usr/bin/python 
#coding:utf-8
    
import os;    

def get_password():
    buf=os.popen(" grep PASSWORD  /root/keystonerc_admin").read();
    array=buf.split("=")[-1].replace("\n", "");
    return array;


def get_xtoken(ip):
    password=get_password();
    url="""
curl -s -X POST http://%s:35357/v2.0/tokens \
    -d '{"auth": {"passwordCredentials": {"username":"admin", "password":"%s"}, "tenantName":"admin"}}'  -H "Content-type: application/json"  |jq -r .access.token.id
"""%(ip,password);
    print url;

    import os;
    p = os.popen(url) 
    x=p.read() 
    a=x.strip();
    print "|%s|"%a;
    return a;

def get_admin_tenant_id(token,ip):
    cmd_str="""
curl -H "X-Auth-Token:%s "  http://%s:5000/v2.0/tenants    |jq -r  .tenants[0].id
"""%(token,ip);
    output=os.popen(cmd_str).read();
    admin_id=output.strip();
    return admin_id;
        

def  gen_cmd(token):
    print """
curl -H "X-Auth-Token:%s "  http://%s:5000/v2.0/tenants  | python -mjson.tool 


#获取版本号：
#get version
curl http://%s:5000/ | python -mjson.tool
curl http://%s:5000/v2.0/ | python -mjson.tool

#获取api扩展：
#get api extensions 
curl http://%s:5000/v2.0/extensions | python -mjson.tool

#更多的url 的获取
可以通过  nova --debug 的方式 获取 url   
#more url can obtain  by nova --debug 

"""%(token,ip, ip ,ip ,ip );


def  get_tenant_server(token,ip,  tenant_id):
    print "#====================================================";
    #curl  -g -i 
    cmd_str="""
    curl -X GET http://%s:8774/v2/%s/servers/detail -H "User-Agent: python-novaclient" -H "Accept: application/json" -H "X-Auth-Token: %s"     |jq -r . 
"""%(ip, tenant_id, token);
    print "CMD: %s"%cmd_str;
    os.system(cmd_str);

#  http://192.168.130.141:8776/v2/2d7407029a3d4c7dac89b86222e119bb/volumes/detail
def  get_cinder_list(token, ip, tenant_id):
    print "#====================================================";
    cmd_str="""
    curl -X GET http://%s:8776/v2/%s/volumes/detail -H "User-Agent: python-novaclient" -H "Accept: application/json" -H "X-Auth-Token: %s"     |jq -r . 
"""%(ip, tenant_id, token);
    print "CMD: %s"%cmd_str;
    os.system(cmd_str);



if __name__=="__main__":
    password=get_password();
    ip="127.0.0.1";

    print  "PASS=%s"%password;
    token=get_xtoken(ip);
    admin_id=get_admin_tenant_id(token,ip);
    print "%s"%admin_id;
    #get_tenant_server(token,  ip ,  admin_id);
    get_cinder_list(token,  ip ,  admin_id);

    #gen_cmd(token);

