cd /var/www/html/

git clone git://github.com/facebook/phabricator.git
git clone git://github.com/facebook/libphutil.git
git clone git://github.com/facebook/arcanist.git

git clone https://secure.phabricator.com/diffusion/P/phabricator.git
git clone https://secure.phabricator.com/diffusion/PHU/libphutil.git
git clone https://secure.phabricator.com/diffusion/ARC/arcanist.git


service mariadb  start 
mysqladmin -u root -p password 

yum install php-mysql 
yum install  php-mbstring 
yum install php-posix
yum install php-gd
yum install tzdata*

cd /var/www/html/phabricator/
./bin/config set mysql.host localhost
./bin/config set mysql.user  root
./bin/config set mysql.pass password

./bin/storage   upgrade 


#create admin user   with  http  web  html 


#==========================================================================
./bin/config set phabricator.base-uri 'http://192.168.1.21/'
./bin/phd start

#mysql  my.cnf 
cat  >>  /etc/my.cnf  <<EOF
innodb_buffer_pool_size=1600M
max_allowed_packet      = 33554432
ft_min_word_len=3
ft_stopword_file=/var/www/html/phabricator/resources/sql/stopwords.txt
sql_mode=STRICT_ALL_TABLES
ft_boolean_syntax=' |-><()~*:""&^'
EOF


#==========================================================================
#yum install   pygments
yum install python-pygments
./bin/config   set  pygments.enabled true
./bin/phd restart


#==========================================================================
 mkdir -p '/var/repo/'
./bin/config   set   repository.default-local-path    "/var/repo/"

#==========================================================================
#post_max_size = 8M
sed '/post_max_size/{s/.*/post_max_size = 256M/g}' -i /etc/php.ini

# upload_max_filesize = 2M
sed '/upload_max_filesize/{s/.*/upload_max_filesize = 256M/g}' -i /etc/php.ini
service httpd restart  

#==========================================================================
cp  phabricator.conf  /etc/httpd/conf.d/

#==========================================================================
mkdir  /tmp3/phabricator_file_disk
chmod 777 -R   /tmp3/phabricator_file_disk
bin/config set   storage.local-disk.path    "/tmp3/phabricator_file_disk"

./bin/phd restart

#==========================================================================
#date.timezone = Asia/Shanghai
sed 's/^;date.timezone \=/date.timezone \= Asia\/Shanghai/g'   -i  /etc/php.ini  



