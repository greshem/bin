#!/bin/sh
function num2ip()
{
#	echo "$1"
    let n=0x$1;
	echo $n

    let o1='(n>>24)&0xff';
    let o2='(n>>16)&0xff';
    let o3='(n>>8)&0xff';
    let o4='n & 0xff';
    echo $o1.$o2.$o3.$o4;
}
num2ip $1
