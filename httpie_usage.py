
#!/usr/bin/python
DATA="""

echo '{"username":"admin","password":"admin"}' | http --session=/tmp/session.json   POST  http://192.168.82.173:22222/api/rest/wzcloud/user/login 
http --session=/tmp/session.json http://192.168.82.173:22222/api/rest/wzcloud/cinder/lis

"""
print DATA;
