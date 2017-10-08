
for each in $(find ./  -maxdepth 1 -type d ); 
do count=$(ls $each |wc -l ); 
echo $count  $each ; 
done
