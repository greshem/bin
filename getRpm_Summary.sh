if [ $# == 0 ];then
echo "Usage: $0 in.rpm "
exit -1;
fi
rpm -qp $1 --qf " %{name} |\t  %{group} |\t  %{summary}\n"
