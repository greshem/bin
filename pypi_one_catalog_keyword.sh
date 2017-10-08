#!/usr/bin/python

if [ !  $# -eq 1 ];then
	echo "Usage: ", $0 , "keyword";
	exit 
fi
keyword=$1;

pip search  $keyword    > /root/pypi_index_$keyword

cd /root/
python /root/bin/pypi_copy_one_keywords.py   > /tmp/tmp.sh 
bash -x  /tmp/tmp.sh 

