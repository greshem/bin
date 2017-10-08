

arp-scan --timeout 5  --interface=br100   192.168.1.0/24  >  /tmp/list

#
#192.168.1.28   f8:32:e4:ba:26:2d		#matt-ubuntu gpu i7  ubuntu 
echo 1. 128G_tangdydi 
grep -i  f8:32:e4:ba:26:2d	 /tmp/list 

echo 2. weihua
grep -i  0c:c4:7a:b2:68:37 /tmp/list 
grep -i  0c:c4:7a:b2:68:36  /tmp/list 
#192.168.1.67   0c:c4:7a:b2:68:37| 0c:c4:7a:b2:68:36    		#gpu  testing  唐宇迪  i7  ubuntu 

echo 3. girl 
#30:5a:3a:c8:8e:af
grep -i  30:5a:3a:c8:8e:af   /tmp/list 

echo 4.  server 192.168.1.33 
grep  30:5a:3a:4c:21:ba	  /tmp/list 
#192.168.1.33   30:5a:3a:4c:21:ba		#matt-zhang-fedo  张哲服务器.   gpu 


