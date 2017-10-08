#!/usr/bin/python 
#pip install --upgrade  psutil
import psutil

#enp2s0
#enp30
def is_net_card(name):
	pattern=["eth","enp","eno","em","ens"]
	for each in pattern:
		if name.startswith(each):
			return  name;
	return None;


#print is_net_card("enp2s0");
#print is_net_card("enp2s0");
	
a=psutil.net_if_stats()
cards=[ is_net_card(key)        for (key,value) in a.items() if is_net_card(key)!=None ] ;
print cards[0]
