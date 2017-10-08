__DATA__
getmail -r  emotibot.conf 
rpm -ql getmail

#出现 root 运行提示 错误. 
grep "refuse to deliver mail as root
grep "refuse to deliver mail as root" /usr/lib/python2.7/site-packages/getmailcore/*.py 
#vim  /usr/lib/python2.7/site-packages/getmailcore/destinations.py 
sed -i 's/raise/print/g'  /usr/lib/python2.7/site-packages/getmailcore/destinations.py   #全部替换 就不会有  uid 之类的错误了. 

getmail -r  emotibot.conf 
ls

#不能支持  相对路径  只 支持 绝对路径. 
du mail_dir/
grep "cannot read contents of parent" 
grep "cannot read contents of parent"  /usr/lib/python2.7/site-packages/getmailcore/*.py 
vim  /usr/lib/python2.7/site-packages/getmailcore/utilities.py 
chmod 777 /root/.getmail/
getmail -r  emotibot.conf 
which getmail
vim /usr/bin/getmail
getmail -r  emotibot.conf 

