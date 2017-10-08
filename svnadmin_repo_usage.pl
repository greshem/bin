#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
svnadmin load /var/svn/new –parent-dir note < note.dump
#==========================================================================
#初级.
svnlook youngest ww_netclone 				//查看到目前为止最新的版本号
svnadmin dump ww_netclone > dumpfile.repo 	//将指定的版本库导出成文件dumpfile
svnadmin load newrepos < dumpfile.repo

#==========================================================================
#  
svnadmin dump ww_netclone -r 23 >rev-23.dumpfile           //将version23导出
svnadmin dump ww_netclone -r 100:200 >rev-100-200.dumpfile  //将version100~200导出

#对比较大的库可以分解成几个文件导出，便于备份
svnadmin dump ww_netclone -r 0:1000 >0-1000.dumpfile
svnadmin dump ww_netclone -r 1001:2000 --incremental >1001-2000.dumpfile
svnadmin dump ww_netclone -r 2001:3000 --incremental >2001:3000.dumpfile

在导入时，可以将这几个备份文件装载到一个新的版本库中
svnadmin load ww_netclone < 0-1000.dumpfile
svnadmin load ww_netclone < 1001-2000.dumpfile
svnadmin load ww_netclone < 2001:3000.dumpfile

#==========================================================================
#advance 
svnadmin dump /path/to/repos > repos-dumpfile
svndumpfilter include RigTMS < repos-dumpfile > RigTMS-dumpfile
svndumpfilter include DocProtect < repos-dumpfile > DocProtect-dumpfile
svndumpfilter include Odin < repos-dumpfile >Odin-dumpfile


svnadmin create RigTMS;svnadmin load RigTMS < RigTMS-dumpfile
svnadmin create DocProtect;svnadmin load DocProtect < DocProtect-dumpfile
svnadmin create Odin;svnadmin load Odin < Odin -dumpfile



#==========================================================================
svnadmin recover /path/to/repos

cat repos-dumpfile | svndumpfilter include calc > calc-dumpfile

########################################################################
########################################################################
svnadmin dump bin > bin.repo

获取 kickstart 的路径,  
#grep Note-path bin.repo 
#grep Node-path bin.repo 

#没有删除空的 提交 
svndumpfilter  include kickstart  < bin.repo  > bin_ks.repo 
svndumpfilter  include kickstart   --drop-empty-revs      < bin.repo  > bin_ks.repo 

svnadmin load  test <  bin_ks.repo 

#==========================================================================
#
trunk\RichEDB\Source\Modules 
md trunk\RichEDB\Source
 
