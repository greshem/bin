#/bin/bash
#/***************************************************
#* Description -  添加vim f5 的时间戳。 
#* Author -      greshem@gmail.com
#* Date -        2010_07_26_18:55:59
#* *************************************************/
#2010_07_26_18:55:52 add by qzj
if ! grep "tabstop=4" /etc/vimrc;then
sed '/history=/a set tabstop=4 \nset shiftwidth=4' /etc/vimrc  -i
fi

sed '/set\s.*tabstop=/{s/.*/set tabstop=4/g}' /etc/vimrc -i 
set '/set\s.*shiftwidth=/{s/.*/set shiftwidth=4/g}'  -i /ec/vimrc

vimrc_append()
{
	cat >> /etc/vimrc<<EOF
	function FileHeading()
		let s:line=line(".")
		call setline(s:line,"/***************************************************")
		call append(s:line,"* Description - ")
		call append(s:line+1,"* Author -      greshem@gmail.com")
		call append(s:line+2,"* Date -        ".strftime("%Y_%m_%d_%T"))
		call append(s:line+3,"* *************************************************/")
		unlet s:line
	endfunction
	function TimeStamp()
		let s:line=line(".")
		call append(s:line,"#".strftime("%Y_%m_%d_%T")." add by qzj")
		unlet s:line
	endfunction

	imap <F7> <esc>mz:execute FileHeading()<CR>'zjA
	imap <F5> <esc>mz:execute TimeStamp()<CR>'zjA
EOF
}

if ! grep "mz:execute TimeStamp" /etc/vimrc;then
	vimrc_append 
else
	echo "/etc/vimrc have modify by qzj\n";
fi


