#!/usr/bin/python
DATA="""
git push ssh://git@dev.lemote.com/rt4ls.git master // 把本地仓库提交到远程仓库的master分支中

git remote add origin ssh://git@dev.lemote.com/rt4ls.git
git push origin master 
这两个操作是等价的，第二个操作的第一行的意思是添加一个标记，让origin指向ssh://git@dev.lemote.com/rt4ls.git，也就是说你操 作origin的时候，实际上就是在操作ssh://git@dev.lemote.com/rt4ls.git。origin在这里完全可以理解为后者 的别名。


########################################################################
git push origin master的意思就是上传本地当前分支代码到master分支。

git push是上传本地所有分支代码到远程对应的分支上。

git push origin test:master         // 提交本地test分支 作为 远程的master分支
git push origin test:test              // 提交本地test分支作为远程的test分支

"""
print DATA; 
