
https://dumps.wikimedia.org/other/kiwix/zim/wikipedia/wikipedia_en_all_2016-06.zim

#64G 
http://download.kiwix.org/portable/wikipedia/kiwix-0.9+wikipedia_en_all_2016-02.zip


# 
# kiwix-serve --port 33440    wikipedia_en_all_2016-06.zim 
#

#libzim 
zimdump zimsearch 

examples:
  zimdump -F wikipedia.zim
  zimdump -l wikipedia.zim
  zimdump -f Auto -i wikipedia.zim
  zimdump -f Auto -d wikipedia.zim
  zimdump -f Auto -l wikipedia.zim
  zimdump -f Auto -l -i -v wikipedia.zim
  zimdump -o 123159 -l -i wikipedia.zim
  zimdump -D output  wikipedia.zim
 
