#coding=utf-8
import jieba
import jieba.posseg as pseg
import time
import  codecs;
import sys;
reload(sys);
sys.setdefaultencoding("utf-8");

    
    

def  seg_one_file(input_file):
    output = codecs.open("%s.seg"%(input_file),'a+','utf-8')

    count=0;
    for each in  open(input_file,"r"):
        count+=1;
        if count%1000==0:
            print count;
        #print each; 
        words = jieba.cut(each) #进行分词
        #print " ".join(words);
        line= " ".join(words);
        output.write( line );

    output.close()

if __name__ == '__main__':
    if len(sys.argv)!=2:
        print "Usage: %s  input_file.txt ";
        sys.exit(-1);

    seg_one_file(sys.argv[1]);
