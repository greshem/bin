#!/bin/bash
# Enables Unicode processing in the current console.
#
# 1. The input side: the keyboard driver.

# Set the keyboard driver in Unicode mode. (Default is ASCII mode.)
# This really does nothing with the way normal keys are handled in
# the kernel. All it does is:
# - It is necessary for `dumpkeys' in order to not drop U+XXXX
#   entries from the keymaps.
# - It is necessary for `loadkeys' in order to avoid warnings.
# - Unicode characters typed as Alt-x1 ... Alt-xn (where x1,...,xn
#   are digits on the numeric keypad) will be emitted in UTF-8.

/bin/kbd_mode -u

# 2. The output side: the console screen.

# Tell the console output driver that the bytes arriving are UTF-8
# encoded multibyte sequences.

if test -t 1 -a -t 2 ; then
	echo -n -e '\033%G'
fi

# Tell the graphics card how to display Unicode characters not
# contained in the IBM 437 character set (on PCs). The font should
# have a Unicode map attached, or explicitly specified, e.g.,
# by giving `def.uni' as a second argument.

DEFAULT_UNICODE_FONT=latarcyrheb-sun16
# Also drdos8x16 is a good candidate.

case $# in
	2)
		/bin/setfont $1 -u $2
		;;
	1)
		/bin/setfont $1
		;;
	0)
		/bin/setfont $DEFAULT_UNICODE_FONT
		;;
	*)
		echo "usage: unicode_start [font [unicode map]]"
		;;
esac
