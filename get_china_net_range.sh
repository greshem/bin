
wget http://ftp.apnic.net/apnic/stats/apnic/delegated-apnic-latest 
grep 'apnic|CN|ipv4' delegated-apnic-latest | cut -f 4,5 -d '|' | tr '|' ' ' | while read ip cnt; do
mask=$(bc <<END | tail -1
pow=32;
define log2(x) {
if (x<=1) return (pow);
pow--;
return(log2(x/2));
}
log2($cnt);
END
); echo $ip/$mask';'>>chinaip.txt; done
cat chinaip.txt 
ls
cd bin/
svn update  
history  -w
