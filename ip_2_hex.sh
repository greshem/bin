function ip_2_x()
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
	echo "0x"$a$b$c$d
}

ip_2_x $1
