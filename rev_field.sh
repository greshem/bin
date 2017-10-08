#!/bin/sh

cat $1|awk  '{for(i=NF;i>0;i--) printf "%s ", $i;print ""}'
