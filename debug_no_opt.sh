
for each in $( find . -name Makefile); do sed -i 's/\-O2/\-g/g' $each; sed -i 's/gcc/gcc/g' $each ; done
for each in $( find . -name Makefile); do sed -i 's/\-O3/\-g/g' $each; sed -i 's/gcc/gcc/g' $each ; done
