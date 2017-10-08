#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

mvn archetype:generate # ：创建 Maven 项目
mvn archetype:generate -DgroupId=com.demo -DartifactId=web-app -DarchetypeArtifactId=maven-archetype-webapp



mvn assembly:assembly

#template  code gen
##old 命令.
mvn archetype:create -DgroupId=com.nuc.test -DartifactId=mytest  

#新的命令  
mvn archetype:generate -DgroupId=com.emotibot  -DartifactId=App
alternatives --config java #-> 1.8 version 
java -classpath  App-1.0-SNAPSHOT.jar   com.emotibot.App  #hello word 
