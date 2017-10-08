#!/usr/bin/python
#ls -l /dev/disk/by-uuid/ 
import glob;
import os;

disk_info={
"/dev/disk/by-uuid/40EC04D2EC04C45E": "/mnt/a",# -> ../../sdi2
"/dev/disk/by-uuid/7C72045F7204208E": "/mnt/b",#../../sdg2 
"/dev/disk/by-uuid/A2CA0AEBCA0ABC13": "/mnt/c", #-> ../../sdb1
"/dev/disk/by-uuid/bc2f5d78-822f-4f71-9015-a5c9de0f4e93":"/mnt/d", # -> ../../sdj1
"/dev/disk/by-uuid/8E2E3C212E3C04AD": "/mnt/e", # -> ../../sdf1
#"/dev/disk/by-uuid/C4FAAE26FAAE1528":"/mnt/f",  #../../sdh2
"/dev/disk/by-uuid/acd8f363-44ab-4b6a-9d1f-0dce1749c2a7":"/mnt/f"  #
}

import commands
for each in glob.glob("/dev/disk/by-uuid/*"):
    if os.path.islink(each):
        if(each in  disk_info.keys()):
            if not os.path.isdir(disk_info[each]):
                os.mkdir(disk_info[each]);
            hdisk=os.path.realpath(each);
            cmd_str="mount %s  %s"% (hdisk, disk_info[each]);
            print ("CMD=%s"%cmd_str);
            output=commands.getoutput(" %s "%cmd_str);
            print output;
