if "%1"=="" (
  echo  %0  input_keyword 
) else (
batchmnt /unmount q:
batchmnt /unmount p:
iso_copy_out_to_desktop.pl "sdb1:\sdb1\_xfile\2013_all_iso\_xfile_2013_07_4of4.iso\\"
echo  iso_copy_out_to_desktop.pl "sdb1:\sdb1\_xfile\2013_all_iso\_xfile_2013_07_4of4.iso\\openvas_2013_08_08.iso"




echo batchmnt /unmount q:
batchmnt /unmount q:
echo  batchmnt.exe P:\openvas_2013_08_08.iso       q /wait
batchmnt.exe P:\openvas_2013_08_08.iso       q /wait
echo findstr /I %1 q:\\list_all_file
findstr /I %1 q:\\list_all_file

)