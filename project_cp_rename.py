#!/usr/bin/python

import glob
import os;
import re;

def is_project_in_it(input_file):
    content=open(input_file).read();
    if 'project' in content:
        return content;
    return None;

#enable 添加10000 然后 再拷贝.
def  copy_enable_file():
    for file in glob.glob("enabled/_1*.py"):
        if os.path.isfile(file):

            reg=re.compile(r'^enabled/_(?P<number>[0-9]+)_.*');
            number= reg.match(file).group('number');
            rename_to_num=int(number)+10000;

            to_file= file.replace("%s"%number, "%s"%rename_to_num);
            print "cp %s  %s "%(file, to_file);


#grep "PANEL_GROUP = 'network'" *.py   
#_1410_network_panel_group.py:PANEL_GROUP = 'network'
#_1420_project_network_topology_panel.py:PANEL_GROUP = 'network'
#_1430_project_network_panel.py:PANEL_GROUP = 'network'
#_1440_project_routers_panel.py:PANEL_GROUP = 'network'
#_1450_project_loadbalancers_panel.py:PANEL_GROUP = 'network'
#_1460_project_firewalls_panel.py:PANEL_GROUP = 'network'
#_1470_project_vpn_panel.py:PANEL_GROUP = 'network'
# 根据  PANEL_GROUP 分类,             

def get_subproject_related_enabled_files(sub_project):
    import os;
    output=os.popen("grep \"PANEL_GROUP = 'network'\"  /root/horizon-dashboard-mitaka-9/openstack_dashboard/enabled/*.py ");
    each= output.readlines();
    for line in each:
        array=[word for word in line.lower().split(":")]
        print os.path.basename(array[0]);

    return array;
    

def mv_sub_project_to_dash_board(sub_project):
    print "cd  /root/horizon-dashboard-mitaka-9/openstack_dashboard/dashboards/  ";
    print " mkdir /root/horizon-dashboard-mitaka-9/openstack_dashboard/dashboards/project_%s"%(sub_project);
    #    print "curl -d'{m}' {u}".format(m=msgstr, u=URL);

    print  """   

cp  project/dashboard.py    project_{name}/dashboard.py
cp  project/__init__.py     project_{name}/__init__.py

sed 's/"project"/"project_{name}"/g'    project_{name}/dashboard.py -i 

sed 's/Project/Project_{name}/g'    project_{name}/dashboard.py -i 


#
cd /root/horizon-dashboard-mitaka-9/openstack_dashboard/enabled
 cp _1000_project.py  _41000_project_{name}.py

 sed 's/project/project_{name}/g'  _41000_project_{name}.py  -i 

    """.format(name=sub_project, title_name=sub_project.capitalize() );


    

import os
print os.path.basename("/etc/passwd")
print os.path.basename(os.getcwd())

import glob
import os;
for file in glob.glob("/root/horizon-dashboard-mitaka-9/openstack_dashboard/dashboards/project/*"):
    if os.path.isdir(file):
        pass
        #print("%s-> %s"%(file, os.path.basename(file)));

#mv_sub_project_to_dash_board("images");

get_subproject_related_enabled_files("network");

