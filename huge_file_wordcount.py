#!/usr/bin/python
DATA="""

cp /etc/passwd /tmp/passwd
sed 's/:/ /g' /tmp/passwd -i """

print DATA;

for each in range(1,12):
    print """
cat /tmp/passwd >> /tmp/tmp
cat /tmp/tmp    >> /tmp/passwd"""

