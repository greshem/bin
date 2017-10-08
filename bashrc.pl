#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ".."="cd ../"
alias "..."="cd ../../"
alias "...."="cd ../../"
alias "....."="cd ../../.."
alias "......"="cd ../../.."


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
. /bin/bash_completion

alias yum="yum -y" 
alias debuginfo-install="debuginfo-install -y " 

PATH=$PATH:/usr/bin:/usr/sbin/:/bin/:/sbin/:/root/bin/

#==========================================================================
if ps $PPID |egrep 'ssh|zhcon' >/dev/null;
then 
export LANG="zh_CN.gb2312"
else
export LANG="zh_CN.UTF8"
fi
