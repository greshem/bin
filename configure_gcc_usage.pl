########################################################################
#gcc 的 specific.html 文档里面提取出来的.
#gcc 的一些参数 target
configure --target=crx-elf --enable-languages=c,c++

#prefix
configure --prefix=/usr/local/

#m68k-*-* 编译选项.
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
#看看  本机的 gcc -v 的 --build --host --target 东西.
