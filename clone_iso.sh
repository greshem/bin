#!/bin/bash

if [ $# == 0 ] ;then
echo "Usage: $0 file.iso";
exit 0
fi
 #cdrecord -eject -v speed=8 dev='/dev/scd0'   -data  $1
 cdrecord -eject -v speed=8 dev='/dev/sr0'   -data  $1

