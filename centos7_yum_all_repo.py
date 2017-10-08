import os
def find_get_dir_list(path):
    filelist=[];
    for root, dirs, files in os.walk(path):

        for file in dirs  :
            abs_path = os.path.join(root,file)
            if "/repodata"  in abs_path  and  os.path.isfile("{0}/{1}".format(abs_path,"repomd.xml")):
                #print abs_path;
                filelist.append(abs_path);
    return filelist;


def file_append(abs_path):
    raw_path=abs_path;
    abs_path=abs_path.replace("./", "");
    abs_path=abs_path.replace("/", "_");

    #fh = open(abs_path, 'a')
    #fh.write("%s\n"%( string) )
    #fh.close();

    import os;
    cwd= os.getcwd();    
    #baseurl="file://%s/%s"%(cwd,raw_path)
    #baseurl="http://greshem.51vip.biz:33444/centos/7.0.1406/%s"%(cwd,raw_path)
    #baseurl="http://greshem.51vip.biz:33444/centos/7.1.1503/%s"%(cwd,raw_path)
    #baseurl="http://greshem.51vip.biz:33444/centos/7.2.1511/%s"%(cwd,raw_path)
    #baseurl="http://greshem.51vip.biz:33444/centos/7.3.1611/%s"%(cwd,raw_path)
    baseurl=baseurl.replace("repodata", "");
    name=abs_path;
    repo="""
[{name}]
name={name}
baseurl=file://{baseurl}
enabled=1
gpgcheck=0
""".format(name=name,baseurl=baseurl);
    print repo;


for each in  find_get_dir_list("./"):
    file_append(each);
