if  echo  $(tty)|grep tty ;then

zhcon
else
touch /.zhcon$(echo $(tty)|sed 's|/|_|g')
fi

if [ -f /.qianlong ];then
	
	if [ -f /.zhcon$(echo $(tty)|sed 's|/|_|g') ];then
		qianlong_startup.sh
	else
		qianlong_start_en.sh
	fi
	rm -f /.qianlong
fi
