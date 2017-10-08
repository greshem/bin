#!/bin/bash

myAxel()
{
    if [ ! -f $2/$(basename $1)  ];then
        if [ ! -d $2 ];then
            mkdir $2;
        fi
        #axel -n 10 $1 -o $2
         wget $1 -P $2
        if [  ! $?  -eq 0 ];then
            echo "axel $1 error "
            echo "axel $1 error " >> axel_error.log
        fi
    else
        echo $2/$(basename $1) , "have download";
    fi
}
