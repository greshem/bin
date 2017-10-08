setenforce  0  
iptables -F 
yum   -y  install java install java-1.7.0 java-1.6.0  java-1.6.0-openjdk unzip wget 

mkdir /tmp3/
mkdir /tmp3/linux_src/

#wget http://greshem.51vip.biz:33444/linux_src/apache-tomcat-7.0.59.zip  -O /tmp3/linux_src/apache-tomcat-7.0.59.zip 
wget http://192.168.1.5:33444/linux_src/apache-tomcat-7.0.59.zip  -O /tmp3/linux_src/apache-tomcat-7.0.59.zip 
#wget http://192.168.1.11/linux_src/apache-tomcat-7.0.59.zip  	

unzip     /tmp3/linux_src/apache-tomcat-7.0.59.zip -d /tmp3/linux_src/ 
chmod +x  /tmp3/linux_src/apache-tomcat-7.0.59/bin/*.sh


cp app.war   /tmp3/linux_src/apache-tomcat-7.0.59/webapps/


echo change port as follow  
echo /tmp3/linux_src/apache-tomcat-7.0.59/conf/server.xml

echo <<EOF
<Connector port="8080" protocol="HTTP/1.1"  
               connectionTimeout="20000"  
               redirectPort="8443" />  
EOF
;


/tmp3/linux_src/apache-tomcat-7.0.59/bin/startup.sh 
/tmp3/linux_src/apache-tomcat-7.0.59/bin/startup.sh 
