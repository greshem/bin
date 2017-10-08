if [ -f /bin/SimSun ];then
convert -background lightblue -fill blue -font /bin/SimSun -pointsize 40 -draw 'text 200,200 "难过 的事情"'  $1 comment_$1
#convert -background lightblue -fill blue -font SimSun -pointsize 48 -draw 'text 200,200 ""'  $1 comment_$1
else
echo /bin/SimSun  does not exist  
fi
