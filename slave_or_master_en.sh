#!/bin/bash
dialog --title "choose master or slave " --radiolist "choose master or slave " 20 60 15 \
  "master" "qianlong master LINUX server " on  \
  "slave"  "qianlong slave  LINUX server " off 2> /.slave_master

