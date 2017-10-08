
#!/usr/bin/python
DATA="""
pip install peewee 
pwiz.py    --password  -e mysql  -t  photo_md5   test   >>  demo.py 


cat >>  demo.py  <<EOF
database.connect();
for i in PhotoMd5.select():
    print i.key

EOF




"""
print DATA;
