#!/bin/bash
exe=$(which hhc.exe) 
if [ -z $exe ];then
	echo "hhc.exe not exists\n";
	exit 
fi
template_HHC_v2.pl 
template_HHK_v2.pl 
template_HPP_v2.pl 
hhc.exe HTML.hpp 
