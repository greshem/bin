
import glob
import os;
for file in glob.glob("/sys/class/net/*"):
    eth_name=file.replace("/sys/class/net/","");
    print "enabling lldp for interface: %s"%file ;  
    if os.path.isdir(file):
        print"""
#==========================================================================
lldptool set-lldp -i {eth_name} adminStatus=rxtx  ;  
lldptool -T -i {eth_name} -V  sysName enableTx=yes;  
lldptool -T -i {eth_name} -V  portDesc enableTx=yes ;  
lldptool -T -i {eth_name} -V  sysDesc enableTx=yes;  
lldptool -T -i {eth_name} -V sysCap enableTx=yes;  
lldptool -T -i {eth_name} -V mngAddr ipv4=192.168.1.333;  
lldptool -T -i {eth_name} -V mngAddr enableTx=yes;  

        """.format(eth_name=eth_name);


