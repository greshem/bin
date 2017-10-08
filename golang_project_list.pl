for(<DATA>)
{
}
__DATA__

cd /home/git_linux_src/
git clone  https://github.com/hackstoic/golang-open-source-projects

for each in $(cat  /home/git_linux_src/golang-open-source-projects/README.md |sed  's/|/\n/g' |grep https:// )
do
    echo $each
done




