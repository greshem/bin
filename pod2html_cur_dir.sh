#!/bin/bash
for each in $(dir -1 |grep pm$)
do
pod2html.pl $each > ${each%%.pm}.html 
done

for each in $(dir -1 |grep pl$)
do
pod2html.pl $each > ${each%%.pl}.html 
done
