#!/bin/sh
# stop unicode
kbd_mode -a
if test -t ; then
	echo -n -e '\033%@'
fi
