#!/bin/sh
cdrecord -v -eject speed=12 dev=1,0,0 -data $1
