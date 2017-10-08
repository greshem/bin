myAxelToFile()
{
	if [ ! -f $2  ];then
		echo $1 $2 >> downding
		#axel -n 10 $1 -o $2
		wget $1 -O $2
		if [  ! $?  -eq 0 ];then
			echo "axel $1 error "
			echo "axel $1 error " >> axel_error.log
		fi
	else
		echo $2 , "have download";
	fi
}

if [ ! $# -eq 2 ];then
	echo Usage: $1 inurl outFIle
fi

myAxelToFile $1 $2
