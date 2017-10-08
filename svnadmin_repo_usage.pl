#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
svnadmin load /var/svn/new �Cparent-dir note < note.dump
#==========================================================================
#����.
svnlook youngest ww_netclone 				//�鿴��ĿǰΪֹ���µİ汾��
svnadmin dump ww_netclone > dumpfile.repo 	//��ָ���İ汾�⵼�����ļ�dumpfile
svnadmin load newrepos < dumpfile.repo

#==========================================================================
#  
svnadmin dump ww_netclone -r 23 >rev-23.dumpfile           //��version23����
svnadmin dump ww_netclone -r 100:200 >rev-100-200.dumpfile  //��version100~200����

#�ԱȽϴ�Ŀ���Էֽ�ɼ����ļ����������ڱ���
svnadmin dump ww_netclone -r 0:1000 >0-1000.dumpfile
svnadmin dump ww_netclone -r 1001:2000 --incremental >1001-2000.dumpfile
svnadmin dump ww_netclone -r 2001:3000 --incremental >2001:3000.dumpfile

�ڵ���ʱ�����Խ��⼸�������ļ�װ�ص�һ���µİ汾����
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

��ȡ kickstart ��·��,  
#grep Note-path bin.repo 
#grep Node-path bin.repo 

#û��ɾ���յ� �ύ 
svndumpfilter  include kickstart  < bin.repo  > bin_ks.repo 
svndumpfilter  include kickstart   --drop-empty-revs      < bin.repo  > bin_ks.repo 

svnadmin load  test <  bin_ks.repo 

#==========================================================================
#
trunk\RichEDB\Source\Modules 
md trunk\RichEDB\Source
 
