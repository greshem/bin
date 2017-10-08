#!/bin/bash
# for each in $(find -type d -name \.svn  )
# do
# echo rm -rf $each
# done

find -type d -name \.svn   | while read line;
do
echo rm -rf \"$line\"
done
