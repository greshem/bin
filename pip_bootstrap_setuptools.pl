#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__


wget https://bitbucket.org/pypa/setuptools/raw/bootstrap/ez_setup.py --no-check-certificate

if [ ! -f  ez_setup.py  ];then
python /bin/ez_setup.py 
else
python  ez_setup.py 
fi


https://pypi.python.org/packages/source/s/setuptools/setuptools-2.2.tar.gz
tar -xzvf  setuptools-2.2.tar.gz
cd  setuptools-2.2
python setup.py install 



wget --no-check-certificate  https://pypi.python.org/packages/source/p/pip/pip-1.5.2.tar.gz

tar -xzvf  pip-1.5.2.tar.gz
cd  pip-1.5.2 
python setup.py install 


pip install pywinauto

 wget https://pypi.python.org/simple/


#=============2015==========
curl -O https://raw.github.com/pypa/pip/master/contrib/get-pip.py
wget  https://raw.github.com/pypa/pip/master/contrib/get-pip.py
python get-pip.py 
pip install crudini 

#=============2016==========
easy_install pip 
pip install ansiable  


wget http://pypi.douban.com/packages/source/p/pip/pip-8.1.1.tar.gz
wget https://bootstrap.pypa.io/get-pip.py
#==========================================================================
wget  http://mirrors.163.com/gentoo/distfiles//pip-8.1.1.tar.gz
wget  http://mirrors.163.com/gentoo/distfiles//pip-8.1.2.tar.gz
wget  http://mirrors.163.com/gentoo/distfiles//pip-9.0.1.tar.gz
