#!/bin/bash
#2010_07_29_18:18:22 add by qzj
html=$1
echo $html
#sed -i 's/\<\//\n\<\//g'  $html
#stytle 需要保留。 , 经过这样的html 导致 </head> 的标记丢失，画面显示处理不是特别好看， 给 //bin/get_html_in_body.pl 的时候， 效果不是特别好。 
#sed -i 's/<\//\n<\//g' $html
sed -i 's/<\//\n<\//g' $html
