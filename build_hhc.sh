#!/bin/sh
#!/bin/sh
function gen_hhk_ul()
{
	echo '	'            \<LI\>\<OBJECT type=\"text/sitemap\"\>
	echo '		'             \<param name="Name" value=\"$1\"\>
	echo '		'               \<param name="Name" value=\"$1\"\>
	echo '		'              \<param name="Local" value=\"$2\"\>
	echo '		'            \</OBJECT\>
}
function gen_header()
{
	echo  \<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML//EN\"\>
	echo  \<HTML\>
	echo  \<HEAD\>
	echo  \<meta name=\"GENERATOR\" content=\"Microsoft\&reg\;\ HTML\ Help\ Workshop\ 4.1\"\>
	echo  \<!-- Sitemap 1.0 --\>
	echo  \</HEAD\>
	echo  \<BODY\>
	echo  \<OBJECT type=\"text/site properties\"\>
	echo  \</OBJECT\>
}

####################
######################
function gen_hhc_ui()
{
	echo '	'            \<LI\>\<OBJECT type=\"text/sitemap\"\>
#	echo '		'             \<param name="Name" value=\"$1\"\>
	echo '		'               \<param name=\"Name\" value=\"$2\"\>
	echo '		'              \<param name=\"Local\" value=\"$1\"\>
	echo '		'            \</OBJECT\>
}
display_file()
{
		tmp_str=$(echo $(pwd)|sed 's/./_/g')		
	#tmp_str=$(pwd)
		for each3 in $(find ./ -type f -maxdepth 1|grep html$ |sort -n )
		do
		#echo "<<<<<<<<<<<<<<<<<<<<<<"
		#echo each3 $each3 
			 echo $each3 |grep html >/dev/null  && name=$(grep TITLE $each3)
		#echo $name
		#echo "<<<<<<<<<<<<<<<<<<<<<<"
		name_last=$(echo $name|sed 's/.*TITLE>\(.*\)<\/TITLE.*/\1/g')
	#	echo $tmp_str $each2 $name
	#		echo $tmp_str $each3 "___ " $name_last
			gen_hhc_ui $each3 $name_last
		done

}
dir_rev() 
{	cd $1
#	echo cd $1
	if [[ $1 == . ]];then
		echo "<UL>"
	else

		echo '	'            \<LI\>\<OBJECT type=\"text/sitemap\"\>
		echo '		'               \<param name="Name" value=\"$(basename $1)\"\>
		echo '		'            \</OBJECT\>
		echo "<UL>"
	fi

	
	
	if [	$(find $(pwd)  -type d -maxdepth 1 |wc -l  ) -eq 1 ];then

		display_file
	else
		display_file
		############
		for each in $( find $(pwd) -type d -maxdepth 1|sort  |sed -ne '2,$p')
		do
			dir_rev $each		
		done

	fi
	echo "</UL>"
}
gen_body()
{
	dir_rev . 
}
#########################################
function gen_foot()
{
	echo  \</BODY\>
	echo  \</HTML\>
	echo  
}
gen_header
gen_body 
gen_foot
