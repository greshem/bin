#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#2011_02_10_ add by greshem

lucene-2.0.0 �б����ͱ���õ�jar ��, 
f13 64bit �� ant   ��ʧ�ܵ�. 

�鿴��
jar -tf lucene-demos-2.0.0.jar
��Ȼ������ demo ����ĺ����� ȷ�������кü��� �� ������main ����. 

ͨ�� jar �ķ�ʽ����
java -jar  lucene-demos-2.0.0.jar  org/apache/lucene/demo/IndexFiles.class
java -jar  lucene-demos-2.0.0.jar  org.apache.lucene.demo.IndexFiles
java -jar  lucene-demos-2.0.0.jar  IndexFiles
��ʧ���� �� 

ͨ�� classpath �ķ�ʽ����, 
java -classpath  lucene-demos-2.0.0.jar  org.apache.lucene.demo.IndexFiles
java -classpath  lucene-demos-2.0.0.jar:lucene-core-2.0.0.jar  org.apache.lucene.demo.IndexFiles
java -classpath  lucene-demos-2.0.0.jar:lucene-core-2.0.0.jar  org.apache.lucene.demo.IndexFiles
�ɹ�

���Զ���������jar �İ� ͨ�� classpath �ķ�ʽ���� �������У� 


ʹ��
strace java -classpath  lucene-demos-2.0.0.jar:lucene-core-2.0.0.jar  org.apache.lucene.demo.IndexFiles src/
�� ������������� ������index Ŀ¼. 


java -classpath  lucene-demos-2.0.0.jar:lucene-core-2.0.0.jar  org.apache.lucene.demo.SearchFiles 
���ļ���������. ��index�ؼ��� �����׵õ����.  


########################################################################
#2011_03_17_23:23:20   ������   add by greshem
javac -classpath lucene-core-2.0.0.jar:. lucene_search.java
java -classpath lucene-core-2.0.0.jar:. lucene_search
�����������û�б��浱ǰĿ¼ �ᵼ�´��� 
java -classpath lucene-core-2.0.0.jar lucene_search


