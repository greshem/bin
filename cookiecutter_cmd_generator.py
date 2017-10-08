import glob
import os;
import os;

   
def print_cmd_code(dir,name): 
    print  """ 
        cd  %s/
        vim  %s/cookiecutter.json 
        cookiecutter  --no-input    %s 
        echo cookiecutter   --config-file  /tmp/cookiecutter.json    %s 
        """%(dir,dir, dir,name);


def do_in_cookie_dir():
    print "#do_in_cookie dir ";
    pwd=os.getcwd();
    name=os.path.basename(os.getcwd())
    json=pwd+"./cookiecutter.json"
    print_cmd_code(pwd, name);


def do_not_in_cookie_dir():
    print "do not _in_cookie dir ";
    for file in glob.glob("/root/.cookiecutters/*"):
        #if os.path.isfile(file):
        if os.path.isdir(file):
            #print(file)
            name=file;
            name=name.replace("/root/.cookiecutters/","");
            print_cmd_code(file,name);
                        
        elif os.path.isfile(file):
            pass
            #print "File:   {0}".format(file);

if __name__ == '__main__':
    pwd=os.getcwd();
    #print type(pwd);
    if "/.cookiecutters/" in  pwd or os.path.isfile("cookiecutter.json"):
        do_in_cookie_dir()
    else:
        do_not_in_cookie_dir()
