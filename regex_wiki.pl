#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
redet

BusyBoxEgrep
C
agrep
arena
awk
bash
cgrep
ed
egrep
emacs
euphoria
expr
fgrep
fish
frink
gawk
glark
grep
groovy
guile
ici
icon
java
javascript
jgrep
judoscript
ksh
lua
mawk
minised
mysql
nawk
nrgrep
numgrep
patmatch
pcregrep
perl
php
php-mb
php-pcre
php-posix
pike
python
rc
rebol
rep
ruby
sed
sleep
sleepwc
ssed
tcl
tclglob
tcsh
tr
vim
wmagrep
zsh
zsh


