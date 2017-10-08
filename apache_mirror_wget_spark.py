#!/usr/bin/python
DATA="""
http://mirrors.hust.edu.cn/apache/spark/

wget   -e robots=off  -r -np  --accept=tgz      http://mirrors.cnnic.cn/apache/spark/

wget   -e robots=off  -r -np  --accept=tar.gz   http://mirrors.cnnic.cn/apache/spark/
wget   -e robots=off -r -np  --accept=tar.bz2   http://mirrors.cnnic.cn/apache/spark/
wget   -e robots=off -r -np  --accept=zip       http://mirrors.cnnic.cn/apache/spark/

"""
print DATA;
