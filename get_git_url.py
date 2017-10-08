#coding=utf-8
import re;
import os;



def is_exists(git_url):
    git_pat=re.compile(git_url);
    
    for each in open("/root/bin/git_projects.pl").readlines():
        if git_pat.search(each): 
            return each
    return None;
    
def file_append(string):
    fh = open("/root/bin/git_projects.pl", 'a+')
    fh.write("%s\n"%( string) )
    fh.close();

def get_git_url(git_config):
    root_pat=re.compile('url.*=');
    git_url=None;
    fh=None;
    try:
        fh=open(git_config);
    except Exception, e:
        return None; 

    for line in fh.readlines(): 
        match=root_pat.search(line)
        if match: 
            array=line.split();
            #print line
            print "APPEND=%s"%line;
            git_url=array[2];
    fh.close();
    return  git_url;

def get_git_dir(root_dir):
    cmd_str="find %s  -maxdepth 2  -name .git  -type d"%root_dir
    import commands
    ifconfig=commands.getoutput(cmd_str);
    output=ifconfig.split("\n");
    for each in output:
        print each;
        git_config="%s/config"%each;
        #print "GGGG%s"%git_config
        if not os.path.isfile(git_config):
            continue;

        git_url=get_git_url(git_config);
        #print "FFFF:%s"%git_url;
        if git_url == None:
            continue;

        if is_exists(git_url):
            #print " 不用添加 %s\n"%git_url
            pass;
        else:
            print " 需要添加 %s"%git_url;
            file_append(git_url);

get_git_dir("/root/linux_src/");
get_git_dir("/root/git_linux_src/");
get_git_dir("/tmp3/linux_src/");
get_git_dir("/home/linux_src/");
get_git_dir("/home/git_linux_src/");
