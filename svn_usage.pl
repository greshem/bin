#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

svn co svn://svn.reactos.org/project-tools/trunk/reactosdbg
svn cp trunk tags/1.0 										#create a tags
svn cp trunk branchs/1.0 									#create a tags
svn merge -r 12972:12991  branches  svn://acer/www/trunk 	#merge
/root/svn_trunk_tags_branches/ 								#have more  examples 
