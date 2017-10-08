#!/usr/bin/python
DATA="""
------------------------------------
ip:  221.228.203.156
user:greshem
pass:E7MFdB10Cq

------------------------------------
#centos7  221.228.203.155或者154
/usr/sbin/openconnect --background --no-cert-check --script=/etc/vpnc/vpnc-script --user=greshem  116.247.127.205
/usr/sbin/openconnect --background --no-cert-check --script=/etc/vpnc/vpnc-script --user=greshem  221.228.203.154
/usr/sbin/openconnect --background --no-cert-check --script=/etc/vpnc/vpnc-script --user=greshem  221.228.203.155


------------------------------------
#fedora25
# --servercert   后面的 sha 不输入的时候 可以 自己打印出来的:
/usr/sbin/openconnect --background   --servercert sha256:fd28407e8f06601107dd3b0c13b0e4c76b46fa3c75fbe472064231b9f98f1e76  --script=/etc/vpnc/vpnc-script --user=greshem 
 116.247.127.205

------------------------------------


"""
print DATA;




