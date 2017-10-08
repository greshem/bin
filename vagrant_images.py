
#!/usr/bin/python
DATA="""
#ubuntu 16-04
vagrant init yk0/ubuntu-xenial; vagrant up --provider libvirt

#Ubuntu 14.04.3 64-bit for libvirt
#matjazp/ubuntu-trusty64  
vagrant init matjazp/ubuntu-trusty64; vagrant up --provider libvirt


#
wget https://atlas.hashicorp.com/s3than/boxes/trusty64/versions/0.0.1/providers/libvirt.box -O  libvirt_s3than_trusty64.img



"""

