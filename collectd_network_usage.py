#!/usr/bin/python
SRV="""
LoadPlugin network
<Plugin "network">
Listen "192.168.1.5"
</Plugin>
"""
print SRV;

CLIENT="""
# Client
LoadPlugin network
<Plugin "network">
Server "192.168.1.5"
</Plugin>
"""
print CLIENT;
