#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
��MySQL����̨�����û�

���� auto-create ������, ����Դ�MySQL����̨����һ���û�.

��Jabberd�û���¼��MySQL����̨:

        mysql -u jabberd2 -p

��MySQL����̨, �л��� jabberd2 ���ݿ�:

        mysql> use jabberd2

��MySQL����̨, ����һ�е� authreg ��. ��һ��Ӧ�ð��� username , realm �� password ��ֵ:

        mysql> insert into authreg (username, realm, password)
            -> values ('myusername', 'somedomain.com', 'mypassword');

�� somedomain.com �޸ĳɷ���������õ�ֵ. �󲿷������, realm�����Jabber��������ID��ͬ. �� myusername �� mypassword �޸ĳ�������û������ƺ�����.

������û����ڿ�����Jabber�ͻ��˵�¼��. 
########################################################################

