#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
#svn commit log 
	 /tmp2/rich_rdonly_svn_path/
#man
	apropos
#registry cygwin /proc/  hivex 

#gdb 
	apropos

iso_search_file.pl
cf.pl
command_find.pl
command_find_extend.pl

perl_inc_goto.pl

sdcv

/bin/yum_search.pl
yum search 

locate |where |which 
/usr/bin/look

cpan search 
perldoc 	tab

#pypi
	yolk

#php 
	php -a  tab

octave 
	completion_matches   key_word

bash
	tab

#readline 

#sourceforge
	/bin/sf_mirror_search_desc.pl 

#cygwin 
	setup.exe

#code index , gtags, htags, calltree 

	

