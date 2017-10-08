#!/usr/bin/python
DATA="""
#tun13  tun0 是自己创建的 而且 ip 是设置好的. 
git clone https://github.com/gregnietsky/simpletun

[server]$ ./simpletun -i tun13 -s
at the other end run

[client]$ ./simpletun -i tun0 -c 10.2.3.4


"""
print DATA;
