#!/bin/bash

#display_errors = Off
if grep "^display_errors = Off" /etc/php.ini >/dev/null ;then
	sed '/^display_errors =/{s/.*/display_errors = On/g}' -i /etc/php.ini
	echo "display_errors is on";
	exit 1
fi

if grep "^display_errors = On" /etc/php.ini >/dev/null ;then
	sed '/^display_errors =/{s/.*/display_errors = Off/g}' -i /etc/php.ini
	echo "display_errors is off";
fi
