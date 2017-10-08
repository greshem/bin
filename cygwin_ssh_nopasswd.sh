#!/bin/bash
cat /root/.ssh/id_rsa.pub |ssh administrator@192.168.1.81 cat '>>'  /home/Administrator/.ssh/authorized_keys
