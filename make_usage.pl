make CC=/usr/local/bin/gcc

#M= 表示模块的路径.
make -C /lib/modules/$(uname -r)/build M=$(pwd)  modules      

#把整个编译的过程打印出来 而不编译.
 make CC="echo gcc"   LD="echo ld" CPP="echo g++"

#增加调试信息 
make BOOT_CFLAGS='-O' bootstrap


