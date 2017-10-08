#!/usr/bin/python
DATA="""
mkdir   /home/svn_git/bin_ext
cd      /home/svn_git/bin_ext
git init --bare


git clone   /home/svn_git/bin_ext/ 
git  push --progress "origin" master:master

"""
print DATA;


