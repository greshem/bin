#coding: utf-8
import chardet
import os;
from chardet.universaldetector import UniversalDetector  


# {'confidence': 0.99, 'encoding': 'GB2312'}
def check_file(file):
    tt=open(file,'rb')

    #ff=tt.readline()
    #ff=tt.readlines()
    #这里试着换成read(5)也可以，但是换成readlines()后报错
    #for each in ff:
    #    enc=chardet.detect(each)
    #print enc['encoding']

    detector = UniversalDetector()  
    for line in tt.readlines():  
        #分块进行测试，直到达到阈值  
        detector.feed(line)  
        if detector.done: break  
    #关闭检测对象  
    detector.close()  


    #print enc;

    ret=detector.result;
    
    tt.close()
    return  ret;

if __name__=="__main__":
    import sys;
    if len(sys.argv)==2:
        ret=check_file(sys.argv[1]);
        print ret;
        sys.exit(-1);


    for root,_,files  in  os.walk("/root/_pre_cache_greshem/"):
        for each in  files:
            abs_path=os.path.join(root,each);
            if abs_path.endswith("txt"):
                ret=check_file(abs_path);
                #encoding': 'GB2312'}
                if ret['encoding']=='GB2312'  or  ret['encoding'] == 'ascii':
                    pass;
                else:
                    print abs_path;
                    print  ret;

#check_file("2016_01_04_周todo.txt");
