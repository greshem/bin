#!/bin/bash
#clone
#/tmp/���ܴ�����ʱ��������õ��ļ��� 
#�������̿��ܻ������
mkisofs -J -r -hide-rr-moved -hide-joliet-trans-tbl -V backup_$(basename $(pwd))_$(/bin/date +%Y_%m_%d)  -o  /tmp/backup_$(basename $(pwd))_$(/bin/date +%Y_%m_%d).iso $(pwd)  &&  cdrecord -eject -v speed=8 dev='/dev/scd0'   -data /tmp/backup_*_$(/bin/date +%Y_%m_%d).iso && rm -f /tmp/backup*.iso
