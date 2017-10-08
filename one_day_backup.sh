#!/bin/bash
cd /root
back_dir_mtime_less_than_n_day.pl 1 |sh
ls
mv *.tar.gz _sync_tar_gz
mv *.tar.gz _sync_tar_gz -f
ls
echo   192.168.1.81:/cygdrive/h/sync/root

scp -r  _sync_tar_gz/  administrator@192.168.1.81:/cygdrive/h/sync/root

