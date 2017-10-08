import os
def find_get_dir_list(path):
    filelist=[];
    for root, dirs, files in os.walk(path):
        for file in files:
            if not file.endswith(".yml"):
                continue;
            abs_path = os.path.join(root,file)
            filelist.append(abs_path);

    return filelist;

def  deal_array(array):
    count=0;
    for each in array:
        if each.startswith("- name"):
            #print "GGG_%s:%s"%(count,array[count]);
            #print "GGG_%s:%s"%(count+1, array[count+1]);
            print "%s"%( array[count+1]);

        count+=1;
             
def  deal_with_one_file(file):
    array= open(file).readlines();
    deal_array(array);
    #for each in array:
    #    print each;


for each in find_get_dir_list("/etc/ansible/roles/"):
    #print "#=======================%s"%each;
    deal_with_one_file(each);
