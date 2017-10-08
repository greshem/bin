#!/usr/bin/python
DATA="""
#

pip install achilterm
achilterm
socat TCP4-LISTEN:8022,bind=0.0.0.0,reuseaddr,fork, TCP4:localhost:8022

/etc/securetty  
pts/0
pts/1
pts/2
pts/3
pts/4pts/3

"""
print DATA;
