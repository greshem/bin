make CC=/usr/local/bin/gcc

#M= ��ʾģ���·��.
make -C /lib/modules/$(uname -r)/build M=$(pwd)  modules      

#����������Ĺ��̴�ӡ���� ��������.
 make CC="echo gcc"   LD="echo ld" CPP="echo g++"

#���ӵ�����Ϣ 
make BOOT_CFLAGS='-O' bootstrap


