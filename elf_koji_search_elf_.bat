if "%1"=="" (
  echo  %0  input_keyword 
) else (


iso_copy_out_to_desktop.pl "sdb1:\sdb1\software_iso\koji_fedora_f18_i386_elf_extract\koji_fedora_f18_i386_4_iso.iso\\"

echo "#===================================\n";
echo findstr /I %1 p:\\file_list_index.txt
findstr /I %1 p:\\file_list_index.txt
)