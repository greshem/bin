########################################################################
#gcc �� specific.html �ĵ�������ȡ������.
#gcc ��һЩ���� target
configure --target=crx-elf --enable-languages=c,c++

#prefix
configure --prefix=/usr/local/

#m68k-*-* ����ѡ��.
configure --with-arch=m68k


#build g
./configure --build=sparc-sun-solaris2.7 

./configure --host=arm-linux 
./configure --target=arm-linux
CC=arm-linux-gcc AR=arm-linux-ar RANLIB=arm-linux-ranlib

#==========================================================================
CC=mipsel-linux-gcc 
./configure --host=mipsel-linux --build=i686-linux --prefix=/opt/tuxbuilder-1.0/mipsel-unknown-linux-gnu/cross --cache-file=mipsel-linux.cache
make
make install

#==========================================================================
#����  ������ gcc -v �� --build --host --target ����.
