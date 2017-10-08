#!/usr/bin/python
import sys;
import os;

def create_libvirt_computer(img_path):
    import jinja2

    templateLoader = jinja2.FileSystemLoader( searchpath="/root/bin/templates/" )
    templateEnv = jinja2.Environment( loader=templateLoader )


    TEMPLATE_FILE = "r1compute1.xml"
    template = templateEnv.get_template( TEMPLATE_FILE )

    name=os.path.basename(img_path)
    name=name.replace(".img","");
    name=name.replace(".qcow2","");

    info={
          "name":name,
          "mac":"fa:16:3e:e4:b0:66",
          "image":img_path,
          "bridge_manage": "mybridge333",
          "bridge_int": "mybridge222",
            };

    bb=template.render( info=info) 
    print bb;

if __name__ == '__main__':
    if len(sys.argv)  != 2:
        print "usage:  %s  input.img "%sys.argv[0];
        sys.exit(0);

    create_libvirt_computer(sys.argv[1]);
