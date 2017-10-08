#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__
#==========================================================================
#wget http://download.wikipedia.com/zhwiki/latest/zhwiki-latest-pages-articles.xml.bz2

##==========================================================================
git clone  https://github.com/attardi/wikiextractor

python WikiExtractor.py -b1000M -o extracted  ../zhwiki-latest-pages-articles.xml_2016_1009  >output.txt  

#==========================================================================
 git clone https://github.com/BYVoid/OpenCC
 opencc   -i wiki_00 -o wiki_chs00  -c /usr/local/share/opencc/t2s.json  
 cmake ./ 
 make install 

