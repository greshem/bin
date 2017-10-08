#!/usr/bin/perl

#4.7.2 ok 
sub deal_with_gcc_4_7_2
{
print <<EOF

../configure  --enable-languages=c --without-headers --with-newlib --disable-shared --disable-threads --disable-libmudflap --disable-libssp  --target=arm  
EOF
;
}





sub deal_with_gcc_4_8_2_one_target($$)
{
	(my $target, my $output_file)=@_;

#--enable-targets=all  \\

open(TARGET, ">".$output_file);

print TARGET  <<EOF
#--prefix=/opt/gcc_4.8.2  
../configure  \\
--target=$target-linux-gnu  \\
--disable-decimal-float  \\
--disable-dependency-tracking  \\
--disable-gold  \\
--disable-libgomp  \\
--disable-libmudflap  \\
--disable-libquadmath  \\
--disable-libssp  \\
--disable-nls  \\
--disable-plugin  \\
--disable-shared  \\
--disable-silent-rules  \\
--disable-sjlj-exceptions  \\
--disable-threads  \\
--disable-checking \\
--disable-libatomic \\
--enable-gnu-unique-object  \\
--enable-initfini-array  \\
--enable-languages=c  \\
--enable-linker-build-id  \\
--enable-nls  \\
--enable-obsolete  \\
--program-prefix=$target-linux-gnu-  \\
--with-linker-hash-style=gnu  \\
--with-newlib  \\
--with-system-libunwind  \\
--with-system-zlib  \\
--without-headers  

EOF
;
	close(TARGET);

}
# deal_with_gcc_4_8_2();

sub gen_4_binutils()
{
	(my $target, my $output_file)=@_;

open(TARGET, ">".$output_file);

print TARGET  <<EOF
	../configure --target=$target-elf --program-prefix=$target-elf
	make -j 8 
EOF
;

	close(TARGET);
}
#our @g_targets=qw(tile  bfin  mips64  m32r  x86_64  h8300  s390x  alpha  c6x   mn10300  frv   sparc64  powerpc64 avr32  cris  m68k  sh64  xtensa  arm   ia64  sh   hppa64  );


if (! -d "gcc/config/")
{
	warn("not in gcc source extract dir \n");
}
for $each (grep {-d} (glob("gcc/config/*")))
{
	$name=$each;
	$name=~s/gcc\/config\///g;

	print $name."\n";	
	mkdir("build_$name");
	deal_with_gcc_4_8_2_one_target($name, "build_$name/start.sh");
	deal_with_gcc_4_8_2_one_target($name, "target_$name.sh");

	mkdir("build_gcc_$name");	
	deal_with_gcc_4_8_2_one_target($name, "build_gcc_$name/start.sh");
	
	
}
