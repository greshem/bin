#coding=utf-8
#加载yaml  
import yaml  

  
#读取文件  
f = open('/root/bin/ansible/0_simplest/webserver.yaml')  

#导入  
x = yaml.load(f)  

print x  
