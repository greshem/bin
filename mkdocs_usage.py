#!/usr/bin/python
DATA="""
pip2 install mkdocs 
mkdocs   new  diary
cd  diary/

mkdocs serve  -a 0.0.0.0:8889
mkdocs serve  -t readthedocs  -a 0.0.0.0:8889
mkdocs build

"""
print DATA;
