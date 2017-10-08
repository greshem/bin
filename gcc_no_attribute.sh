gcc -E $1 > tmp
qindent.sh tmp
sed 's/__attribute__ ((__nothrow__))//g' tmp -i
 sed 's/__attribute__ ((__nonnull__(2)))//g' tmp -i
 sed 's/__attribute__ ((__nonnull__(1)))//g' tmp -i
 sed 's/__attribute__ ((__nonnull__(3)))//g' tmp -i
 sed 's/__attribute__ ((__nonnull__(1, 2)))//g' tmp -i 
 sed 's/__attribute__ ((__malloc__))//g' tmp -i
 sed 's/ __attribute__ ((__noreturn__))//g' tmp -i
 sed 's/__attribute__ ((__nonnull__(1, 2, 5))//g' tmp -i
 sed 's/__attribute__ ((__const__))//g' tmp -i 
 sed 's/ __attribute__ ((__warn_unused_result__))//g' tmp -i 
 sed 's/ __attribute__ ((cdecl))//g' tmp -i
 sed '/^#/d' tmp -i
