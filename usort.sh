#!/bin/sh
#echo $#
#echo $1
cp $1 /tmp/$1.bak

if [ $# -ne 1 ]; then
echo "Usage: $0 file"
exit 3
fi
word=$(wc -l $1|awk '{print $1}')
for ((i=$word ; i>=1 ;i--))
do
a=$(expr $RANDOM % $i + 1)
sed -ne "$a p" $1
sed -i "$a d" $1
done
yes |cp /tmp/$1.bak $1
