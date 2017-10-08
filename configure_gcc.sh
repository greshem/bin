
pwd=$(pwd)/
echo ../configure --enable-checking=release --enable-languages=c,c++ --disable-multilib  --prefix=/opt/$(basename $pwd)  && make -j8 
../configure --enable-checking=release --enable-languages=c,c++ --disable-multilib  --prefix=/opt/$(basename $pwd)  && make -j8 
