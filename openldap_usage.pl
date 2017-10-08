#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ ;
}
__DATA__
yum install openldap* 

sed 's/my-domain/tnsoft/g'  /etc/openldap/slapd.conf
#echo rootpw		secret
service slapd  restart 

include /etc/openldap/schema/iaas.schema

chown -R ldap:ldap /etc/openldap/slapd.d
chown -R ldap:ldap /var/lib/ldap


#inmport , mail should commit 
ldapadd -x -D "cn=Manager, dc=tnsoft, dc=com" -w secret -f tnsoft.com_organization.ldif
ldapadd -x -D "cn=Manager, dc=tnsoft, dc=com" -w secret -f tnsoft.com_user.ldif



ldapsearch  -x -b '' -s base '(objectclass=*)'

ldapsearch  -x -b 'dc=tnsoft,dc=com' 
ldapsearch  -x -b 'dc=tnsoft,dc=com' "*"

ldapsearch  -x -b 'dc=tnsoft,dc=com' "cn=test1"
ldapsearch  -x -b 'dc=tnsoft,dc=com' "cn=test1" "uid=21"

ldapsearch  -x -b 'dc=tnsoft,dc=com' 'cn=service2'
ldapsearch  -x -b 'dc=tnsoft,dc=com' -s base '(objectclass=*)'
ldapsearch  -x -b 'dc=tnsoft,dc=com' -s base 'objectclass=*'
ldapsearch  -x -b 'dc=tnsoft,dc=com' -s base 'cn=service2'
ldapsearch  -x -b 'dc=tnsoft,dc=com' -s base 'cn=*'

