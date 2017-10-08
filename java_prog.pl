#!/usr/bin/perl
$pattern=shift;
foreach (<DATA>)
{
	print $_ if($_=~/$pattern/i);
}
__DATA__
svnstat
lucene
ant
tomcat
jboss
zureus.noarch

bsh.noarch
jmail
eclipse-birt.noarch

findbugs.noarch
freemind

ini4j.noarchimagej.noarch :

jaxen.noarch

