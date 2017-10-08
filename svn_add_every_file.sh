#!/bin/bash
# for each in $(find -type d -name \.svn  )
# do
# echo rm -rf $each
# done

find  |grep -v ".svn"   | while read line;
do
svn add "$line"
done
