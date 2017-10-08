#!/usr/bin/python 

DATA="""
cd /tmp &&  curl -L 'http://download.oracle.com/otn-pub/java/jdk/7u65-b17/jdk-7u65-linux-x64.tar.gz' -H 'Cookie: oraclelicense=accept-securebackup-cookie; gpw_e24=Dockerfile' | tar -xz  

mkdir -p /usr/lib/jvm  
cd /tmp
cd  jdk1.7.0_65/

mv /tmp/jdk1.7.0_65/ /usr/lib/jvm/java-7-oracle/  

 update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-7-oracle/bin/java 300     
 update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/java-7-oracle/bin/javac 300   
export JAVA_HOME=/usr/lib/jvm/java-7-oracle/ 
echo JAVA_HOME=/usr/lib/jvm/java-7-oracle/  >> /root/.bashrc
""";
print DATA;
