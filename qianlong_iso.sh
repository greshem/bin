#!/bin/bash
cd / 
rm -f qianlong_iso.tar.gz 
tar -cf qianlong_iso.tar qianlong_iso/
echo "add /bin/*.sh";
tar -rvf qianlong_iso.tar /bin/*.sh
echo "add /bin/*.pl";
tar -rvf qianlong_iso.tar /bin/*.pl
gzip qianlong_iso.tar 
