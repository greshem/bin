
for each in $(./glob.pl /tmp2/root_backup20100206/)
do

if  grep $each /tmp/done;then
continue;
fi
echo mkisofs -J -input-charset gbk -r -hide-rr-moved -hide-joliet-trans-tbl -V root_20100206 -o root_backup20100206_.iso  $each
 mkisofs -J -input-charset gbk -r -hide-rr-moved -hide-joliet-trans-tbl -V root_20100206 -o root_backup20100206_.iso  $each
if [ ! $? -eq 0 ];then
 	echo mkisofs -J -input-charset gbk -r -hide-rr-moved -hide-joliet-trans-tbl -V root_20100206 -o root_backup20100206_.iso  $each
	exit;
else
	echo $each >> /tmp/done
fi
done
