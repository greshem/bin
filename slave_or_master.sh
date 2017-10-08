#!/bin/bash
dialog --title "选择主备安装" --radiolist "选择主备安装" 20 60 15 \
  "master" "主用LINUX服务器" on  \
  "slave"  "备用LINUX服务器" off 2> /.slave_master

