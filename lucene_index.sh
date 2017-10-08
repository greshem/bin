#!/bin/bash
#2011_02_28_21:28:37 ÐÇÆÚÒ»  add by greshem

classspath=
a=$(rpm -ql lucene |grep jar$)
for each in $a
do
	echo $each
	classpath=$each:$classpath
done

b=$(rpm -ql lucene-demo |grep jar$)
for each in $b
do
	echo $each
	classpath=$classpath:$each
done

echo classpath=$classpath


# for each in $(cat /tmp/tmp2)
# do
# echo java -classpath \$classpath   $each
# done

echo java -classpath \$classpath org.apache.lucene.demo.DeleteFiles
echo java -classpath \$classpath org.apache.lucene.demo.FileDocument
echo java -classpath \$classpath org.apache.lucene.demo.HTMLDocument
echo java -classpath \$classpath org.apache.lucene.demo.IndexFiles
echo java -classpath \$classpath org.apache.lucene.demo.IndexHTML
echo java -classpath \$classpath org.apache.lucene.demo.SearchFiles$OneNormsReader
echo java -classpath \$classpath org.apache.lucene.demo.SearchFiles
echo java -classpath \$classpath org.apache.lucene.demo.html.Entities
echo java -classpath \$classpath org.apache.lucene.demo.html.HTMLParser$JJCalls
echo java -classpath \$classpath org.apache.lucene.demo.html.HTMLParser$LookaheadSuccess
echo java -classpath \$classpath org.apache.lucene.demo.html.HTMLParser$MyPipedInputStream
echo java -classpath \$classpath org.apache.lucene.demo.html.HTMLParser
echo java -classpath \$classpath org.apache.lucene.demo.html.HTMLParserConstants
echo java -classpath \$classpath org.apache.lucene.demo.html.HTMLParserTokenManager
echo java -classpath \$classpath org.apache.lucene.demo.html.ParseException
echo java -classpath \$classpath org.apache.lucene.demo.html.ParserThread
echo java -classpath \$classpath org.apache.lucene.demo.html.SimpleCharStream
echo java -classpath \$classpath org.apache.lucene.demo.html.Tags
echo java -classpath \$classpath org.apache.lucene.demo.html.Test
echo java -classpath \$classpath org.apache.lucene.demo.html.Token
echo java -classpath \$classpath org.apache.lucene.demo.html.TokenMgrError
