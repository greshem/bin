function ip2hex()
{
local a b c d 
a=$(echo $1|cut -d\. -f1)
b=$(echo $1|cut -d\. -f2)
c=$(echo $1|cut -d\. -f3)
d=$(echo $1|cut -d\. -f4)
a=$(printf %X $a)
 [ $(expr length $a) -eq 1 ]&&a=0$a
b=$(printf %X $b)
 [ $(expr length $b) -eq 1 ]&&b=0$b
c=$(printf %X $c)
 [ $(expr length $c) -eq 1 ]&&c=0$c
d=$(printf %X $d)
 [ $(expr length $d) -eq 1 ]&&d=0$d
echo $a$b$c$d
}
function hex2ip()
{
#	echo "$1"
    let n=0x$1;
#	echo $n

    let o1='(n>>24)&0xff';
    let o2='(n>>16)&0xff';
    let o3='(n>>8)&0xff';
    let o4='n & 0xff';
    echo $o1.$o2.$o3.$o4;
}
function number2ip()
{
    let n="$1";

    let o1='(n>>24)&0xff';
    let o2='(n>>16)&0xff';
    let o3='(n>>8)&0xff';
    let o4='n & 0xff';
    echo $o1.$o2.$o3.$o4;
}

function ip2number()
{
local a b c d 
d=$(echo $1|cut -d\. -f1)
c=$(echo $1|cut -d\. -f2)
b=$(echo $1|cut -d\. -f3)
a=$(echo $1|cut -d\. -f4)
sum=0
sum=$((d*256*256*256+c*256*256+b*256 +a))
echo $sum
}
####################################################
echo ------------------
echo ip2hex    192.168.3.222
ip2hex    192.168.3.222
echo ------------------
echo ip2number 192.168.3.222
ip2number 192.168.3.222
echo ------------------
echo hex2ip    C0A803DE
hex2ip    C0A803DE
echo ------------------
echo number2ip 3232236510
echo $(number2ip  $(expr $(ip2number 192.168.3.222) + 1 ))
echo ------------------

