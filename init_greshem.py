#!/usr/bin/python 
#coding: utf-8
# /root/bin/port_333_list.py


print """
#英语单词        33333           foreign_trade_management_sys/flask_v2
cd /root/foreign_trade_management_sys/flask_v2/ 
bash  /root/foreign_trade_management_sys/flask_v2/start.sh


#blog            33334           /home/git_linux_src/blog
cd /home/git_linux_src/blog/start.sh 

#kiwix           
#wiki_en_60G     33439           /mnt/d/kiwix-0.9+wikipedia_en_all_2015-05/output_extract/data/content/ 
cd /mnt/d/kiwix-0.9+wikipedia_en_all_2015-05/output_extract_60G/data/content/ 



#
#mathics         33440           mathicsserver and socat TCP4-LISTEN:33440,reuseaddr,fork, TCP4:localhost:8000
mathics


#photo           33441           /home/git_linux_src/Photo-Gallery
cd /home/git_linux_src/Photo-Gallery
python app.py


#openstack       33444           service httpd restart
#var_www_html    33444           service httpd restart

#juypter         33443           jupyter-notebook --port=33443 --ip=0.0.0.0
cd /root/juypter/
jupyter-notebook --port=33443 --ip=0.0.0.0




"""
