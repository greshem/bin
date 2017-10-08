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
function gen_body()
{
	echo "\<UL\>"
	for each in $(find D R S) ; 
	do 
		echo $(grep TITLE $each) $each ;
	done |sed -e 's/<TITLE>//g' -e 's/<\/TITLE>//g' >error
	cat error  |while read name file;  
	do
		 gen_hhk_ul  $name $file;
	done
	echo "\</UL\>"
}
function gen_foot()
{
	echo  \</BODY\>
	echo  \</HTML\>
	echo  
}
gen_header
gen_body 
gen_foot
