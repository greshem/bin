if "%1"=="" (
  echo  %0  input_keyword 
) else (
batchmnt /unmount q:
batchmnt /unmount p:


 iso_copy_out_to_desktop.pl "sdb1:\sdb1\_xfile\2014_all_iso\_xfile_2014_09_10.iso\\_xfile_2014_09\\users_2014_0930\\"



echo  cd P:\_xfile_2014_09\users_2014_0930\
cd P:\_xfile_2014_09\users_2014_0930\

echo p:
P:

echo  perl grep.pl  %1
perl grep.pl  %1

)