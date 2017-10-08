#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
yum install mod_svn_dav
yum install mod_dav_svn
########################################################################
# /etc/httpd/conf.d/subversion.conf
########################################################################
#�����Ҫ. 
LoadModule dav_svn_module     modules/mod_dav_svn.so
LoadModule authz_svn_module   modules/mod_authz_svn.so

#�������һ���ֿ�,  ������һ��Ŀ¼  repo �� ��ʽ�� format 
<Location /svn>
	DAV svn
	SVNPath /home/svn
	AuthType Basic
	AuthName "myproject subversion repository"
	AuthUserFile /etc/subversion/passwd
	Require valid-user
</Location>

#1. һ��Ŀ¼ Ȼ�� ��������кܶ�Ĳֿ� ���Բο� visual svn �� �����ļ� windows �汾��. 

########################################################################
�����ļ�

<Location /svn>
	DAV svn
	SVNParentPath /home/svnuser/svn
	AuthType Basic
	AuthName "myproject subversion repository"
	AuthUserFile /etc/subversion/passwd
	Require valid-user
</Location>
########################################################################

4. �û���֤
#������������Ҫ���� /etc/subversion/passwd �ļ������ļ��������û���Ȩ����ϸ��Ϣ��Ҫ����û���������ִ����������
sudo htpasswd -c /etc/subversion/passwd user_name
#������ʾ���������룬�������������룬���û��ͽ�����
#���������û�ȥ��-c����������
sudo htpasswd /etc/subversion/passwd user_name

5.  �ñ��ݵ� repo ��ѹ֮��. 
#������ͨ������������������ļ��ֿ⣺
#$ svn co http://hostname/svn/myproject
#������ʾ�������û��������롣������������ʹ�� htpasswd ���õ����롣��ͨ����֤����Ŀ���ļ��ͱ�ǩ����

6.  svn �ĵ�����Բο�  /root/bin/svn_import_local_to_server.pl
########################################################################
htpasswd -c /etc/subversion/passwd root
htpasswd  /etc/subversion/passwd greshem
htpasswd  /etc/subversion/passwd wenshuna


