
cd $(dirname $1);
get_root_dir.sh $(basename $1) >__rand_file
if [ $? -eq 1 ];then
 	tar -xzf $1;
	if [ $? -eq 0 ];then
	
 		echo cd $(cat __rand_file);
 		cd $(cat __rand_file);
 		gtags&&htags&&chmod 777 HTML
 		tar -czf $(cat ../__rand_file).chm.tar.gz HTML
 		cp $(cat ../__rand_file).chm.tar.gz ../
#		rm -f __rand_file
	fi
else

	echo "two many dirs "
fi

