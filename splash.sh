#!/bin/bash
#
# splash.sh - script to paint progress bar during
# system startup/shutdown. This script is solely run
# by the init scripts (shell function rc_splash)
#
# (w) 2002-2003 Stefan Reinauer, <stepan@suse.de>
# It's licensed under GPL, of course.
#
# Adapted to RedFlag Linux, improved for i18n, optimized
#
# this script expects the following environment variables:
#  sscripts = number of start scripts to be executed for runlevel change
#  kscripts = number of stop scripts to be executed for runlevel change
#  progress = number of currently executed start/stop script
#  runlevel = runlevel to be reached.
export LANG=en_US
export LC_ALL=en_US
_procsplash="`cat /proc/splash 2>/dev/null`"

# execute splash binary utility because we are a wrapper:
if [ "$1" == "-s" -o "$1" == "-u" -o "$1" == "-n" -o "$1" == "-f" ]; then
    exec /sbin/splash $*
else
   ( exec /sbin/splash "$*" )
fi

# assertions
test -r /proc/splash || exit 0
test -z "$progress" -a -z "$num" && exit 0
test -z "`echo $_procsplash|grep on`" && exit 0
test "`cat /proc/cmdline |grep \"splash=silent\"`" == "" && exit 0 # We chose verbose in grub

if [ "$previous" == "3" -o "$previous" == "5" ] ; then
  if [ "$runlevel"  = "3" -o "$runlevel" == "5" ] ; then
    exit 0
  fi
fi

# assertion to catch bootsplash <2.1

# acquire data
# 
_shutdown="no"
_silent="no"
test "`cat /proc/splash |grep silent`" && _silent="yes"
test "$runlevel" == "6" -o "$runlevel" == "0" && _shutdown="yes"
if test "$_shutdown" == "yes"; then
  num=$(( $kscripts + 1 ))
else
  num=$(( $sscripts + 1 ))
fi

function box() { true; } # ignore box descriptions in the config file

if [ -f /etc/bootsplash/themes/current/config/bootsplash-`fbresolution`.cfg ]; then
  . /etc/bootsplash/themes/current/config/bootsplash-`fbresolution`.cfg
elif [ -f /etc/bootsplash/bootsplash-`fbresolution`.cfg ]; then
  . /etc/bootsplash/bootsplash-`fbresolution`.cfg
fi

# Print text string..
if [ "$progress" == 1 -o "$1" == "splash start" ]; then
    if test "$_shutdown" == "yes"; then
      chvt 1
      splash -s -u -n /etc/bootsplash/themes/current/config/bootsplash-`fbresolution`.cfg
	  sh /sbin/fbstop.sh
    else
	  sh /sbin/fbstart.sh
    fi
fi
# Paint progressbar..
if test "$_shutdown" == "yes"; then
	test -z "$progress_enable" || echo "show $(( 225534 * ( $progress + 1 ) / $num ))" > /proc/splash
else
	test -z "$progress_enable" || echo "show $(( 65534 * ( $progress + 1 ) / $num ))" > /proc/splash
fi	
