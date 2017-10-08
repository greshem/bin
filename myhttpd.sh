#!/bin/sh -eufC
# vim:set ai sw=2 ts=2:
#
# http server (with inetd.conf)
# www stream tcp nowait nobody /bin/sh sh -eufC /usr/local/libexec/httpd.sh
#
# Copyright (c) 2006 Pavel I Volkov
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
#
# $Id: httpd.sh,v 1.4 2006/08/19 12:50:21 known Exp $
#
# $Log: httpd.sh,v $
# Revision 1.4  2006/08/19 12:50:21  known
# change in fpost(), bad Content-Length header
#
# Revision 1.1.1.1  2006/08/19 12:26:55  known
# Import into sf.net
#
# Revision 1.3  2006/08/18 09:12:03  pol
# I hope method POST now works.
#
# Revision 1.2  2006/08/17 14:48:33  pol
# Change delimiter logic into freadheader() function, change SERVER_SOFTWARE variable.
#
# Revision 1.1  2006/08/17 12:41:20  pol
# Initial revision
#
#

export DOCUMENT_ROOT="/var/www/html/"
DEFFILE="index.html.koi8-r"
ACCESSLOG="YES"

export SERVER_SOFTWARE="httpd.sh/1.4"
export SERVER_PROTOCOL="HTTP/1.0"
export SERVER_NAME=`hostname`
ALLOW="GET, HEAD, POST"
DATEFORMAT="%a, %d %b %Y %T %Z"

export LC_TIME=C
flog() { local l=$1; shift; logger -i -t `basename $0` -p "daemon.$l" "$*"; }
fheadgen() {
	date "+Date: ${DATEFORMAT}"
	echo "Server: ${SERVER_SOFTWARE}"
	echo "Allow: ${ALLOW}"
}
ferrgen() {
	echo "$*"
	fheadgen
	echo 'Content-type: text/html; charset=ISO-8859-1'
	echo ''
	echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'
	echo '<html xmlns="http://www.w3.org/1999/xhtml">'
	echo '<head><title>' "$*" '</title>'
	echo '</head><body>'
	echo '<H1>' "$*" '</H1>'
	echo '</body></html>'
}
freply() {
	echo -n "$SERVER_PROTOCOL" "$1 "
	case "$1" in
		200) echo "OK"; fheadgen;;
		201) ferrgen "Created";;
		202) ferrgen "Accepted";;
		204) ferrgen "No Content";;
		300) ferrgen "Multiple Choices";;
		301) ferrgen "Moved Permanently";;
		302) ferrgen "Moved Temporarily";;
		304) ferrgen "Not Modified";;
		400) ferrgen "Bad Request";;
		401) ferrgen "Unauthorized";;
		403) ferrgen "Forbidden";;
		404) ferrgen "QIANZHONGJIE Not Found";;
		500) ferrgen "Internal Server Error";;
		501) ferrgen "Not Implemented";;
		502) ferrgen "Bad Gateway";;
		503) ferrgen "Service Unavailable";;
		*) ferrgen "$2";;
	esac
}
fcheckurl() { echo "$1" | egrep -qv '/?\.\./?'; return $?; }
fmime() {
	echo -n 'Content-type:' `file -ib $1 | cut -f 1 -d ' ' | tr -d ';'`
	if [ -e ${1%".koi8-r"}.koi8-r ]; then echo -n "; charset=KOI8-r"
	elif [ -e ${1%".cp-1251"}.cp-1251 ]; then echo -n "; charset=WINDOWS-1251"
	elif [ -e ${1%".utf8"}.utf8 ]; then echo -n "; charset=UTF-8"
	else echo -n "; charset=ISO-8859-1"; fi
	echo ''
}
flastmodified() { date -jr `stat -nqf "%m" "$1"` "+Last-Modified: ${DATEFORMAT}"; }
fget() {
	if fcheckurl "$1"; then
		if [ -f "$1" -a -x "$1" ]; then # this is CGI
			freply 200
			if [ "$REQUEST_METHOD"="GET" ]; then
				if [ "$ACCESSLOG"="YES" ]; then flog info "GET CGI $1"; fi
				exec "$1"
			elif [ "$REQUEST_METHOD"="HEAD" ]; then
				if [ "$ACCESSLOG"="YES" ]; then flog info "HEAD CGI $1"; fi
			fi
		elif [ -f "$1" -a -r "$1" ]; then
			freply 200
			fmime "$1"
			flastmodified "$1"
			if [ "$REQUEST_METHOD"="GET" ]; then
				if [ "$ACCESSLOG"="YES" ]; then flog info `stat -nqf "GET %z $1" "$1"`; fi
				echo ""
				cat "$1"
			elif [ "$REQUEST_METHOD"="HEAD" ]; then
				if [ "$ACCESSLOG"="YES" ]; then flog info `stat -nqf "HEAD %z $1" "$1"`; fi
			fi
		else freply 404; flog error "File ${1} not found"; fi
	else freply 400; flog error "Bad request in URL: ${1}"; fi
}
fpost() { local line
	if fcheckurl "$1"; then
		if [ -f "$1" -a -x "$1" ]; then # this is CGI
			freply 200
			if [ "$ACCESSLOG"="YES" ]; then flog info "POST CGI $1"; fi
			if [ $HTTP_CONTENT_LENGTH -gt 0 ]; then
				dd count=1 bs=$HTTP_CONTENT_LENGTH | exec "$1"
			else freply 400; flog error "Bad Content-Length header in POST method on URL: ${1}"; fi
		else freply 403; flog error "File ${1} is not CGI and method POST not allowed on it"; fi
	else freply 400; flog error "Bad request in URL: ${1}"; fi
}
freadheader() {
	local e v=" "
	while [ -n "$v" ]; do
		read v e
		v=`echo $v | tr -d '\12\15'`; e=`echo $e | tr -d '\12\15'`
		if [ -n "$v" ]; then
			export HTTP_`echo $v|tr -d ':'|tr '\41\43\44\45\46\47\52\53\55\56\100\136\140\174\176' '_'|tr "[:lower:]" "[:upper:]"`="$e"
		fi
	done
}
fnorm() {
	SCRIPT_NAME="/${SCRIPT_NAME#/}"
	echo "$SCRIPT_NAME" | egrep -q '.*/$' && SCRIPT_NAME="${SCRIPT_NAME}${DEFFILE}"
	export SCRIPT_FILENAME="${DOCUMENT_ROOT}${SCRIPT_NAME}"
}
freadstatusline() {
	local version OIFS="$IFS"; IFS="${IFS}?"
	read REQUEST_METHOD SCRIPT_NAME QUERY_STRING REQUEST_PROTOCOL
	IFS="$OIFS"
	if [ -z "$REQUEST_PROTOCOL" ]; then REQUEST_PROTOCOL="$QUERY_STRING"; QUERY_STRING=""; fi
	REQUEST_PROTOCOL=`echo $REQUEST_PROTOCOL | tr -d '\12\15'`
	if [ -n "$QUERY_STRING" ]; then REQUEST_URI="${SCRIPT_NAME}?${QUERY_STRING}"; else REQUEST_URI="${SCRIPT_NAME}"; fi
	export REQUEST_METHOD SCRIPT_NAME QUERY_STRING REQUEST_URI REQUEST_PROTOCOL
}

freadstatusline
freadheader
fnorm
case "$REQUEST_METHOD" in
	[Gg][Ee][Tt]) fget "$SCRIPT_FILENAME";;
	[Hh][Ee][Aa][Dd]) fget "$SCRIPT_FILENAME";;
	[Pp][Oo][Ss][Tt]) fpost "$SCRIPT_FILENAME";;
	*) freply 501; flog notice "HTTP method $REQUEST_METHOD on $REQUEST_URI is unknown";;
esac
