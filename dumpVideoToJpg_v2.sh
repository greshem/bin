#!/bin/bash
if [ $# -eq 0 ];then
	echo "Usage: $0 video_file";
	exit 1;
fi
#mplayer $1 -sstep 10 -vo jpeg -ao null
mplayer $1 -sstep 10 -vo png -ao null
