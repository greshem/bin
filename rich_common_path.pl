#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
/root/dlxp_windrv/
/root/dlxp_bootldr/

/tmp2/rich_rdonly_svn_path/diskless_clntools/trunk #pnp
/tmp2/rich_rdonly_svn_path/diskless_rich 		#netbar

/tmp2/rich_rdonly_svn_path/dlxp_bootldr/
/tmp2/rich_rdonly_svn_path/dlxp_windrv/trunk

/tmp2/rich_rdonly_svn_path/richdlxp/trunk/InstClt #2500

