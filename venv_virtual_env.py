#!/usr/bin/python
string="""
virtualenv --no-site-packages /root/venv/keystone8     # l
virtualenv --no-site-packages /root/venv/keystone9     # m vesion
virtualenv --no-site-packages /root/venv/keystone10     # n ver

virtualenv --no-site-packages /root/venv/django_1.9     #
virtualenv --no-site-packages /root/venv/django_1.8     #

virtualenv --no-site-packages /root/venv/horizon-2015.1.2    
virtualenv --no-site-packages /root/venv/horizon_8.0.1/
virtualenv --no-site-packages /root/venv/horizon-9.0.1/

virtualenv --no-site-packages venv      #
virtualenv --system-site-packages venv  #
source venv/bin/activate
deactivate 
"""
print string;
