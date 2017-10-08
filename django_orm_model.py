#!/usr/bin/python
DATA="""
#1. 
django-admin.py startproject bbbb 
cd bbbb         
django-admin.py startapp people # 新建一个 people 应用（app)

#2. 将我们新建的应用（people）添加到 settings.py 中的 INSTALLED_APPS中

#3.我们打开 people/models.py 文件，修改其中的代码如下：
from django.db import models
class Person(models.Model):
    name = models.CharField(max_length=30)
    age = models.IntegerField()

#4.
# Django 1.6.x 及以下
python manage.py syncdb
 
# Django 1.7 及以上的版本需要用以下命令
python manage.py makemigrations
python manage.py migrate

#5.   python code 
#--------------------------------------------------------------------------
#create 
from people.models import Person

    1. Person.objects.create(name="WeizhongTu", age=24)
    2. Person.objects.create(name=name,age=age)

    3. p = Person(name="WZ", age=23)
       p.save()
    4. 
        p = Person(name="TWZ")
        p.age = 23
        p.save()
    5:
        Person.objects.get_or_create(name="WZT", age=23)

#--------------------------------------------------------------------------


1.获取对象有以下方法：
Person.objects.get(name="WeizhongTu")
Person.objects.all()
Person.objects.all()[:10] 切片操作，获取10个人，不支持负索引，切片可以节约内存
Person.objects.get(name=name)

2. 如果需要获取满足条件的一些人，就要用到filter
Person.objects.filter(name="abc")           # 等于Person.objects.filter(name__exact="abc") 名称严格等于 "abc" 的人
Person.objects.filter(name__iexact="abc")   # 名称为 abc 但是不区分大小写，可以找到 ABC, Abc, aBC，这些都符合条件
Person.objects.filter(name__contains="abc") # 名称中包含 "abc"的人
Person.objects.filter(name__icontains="abc")#名称中包含 "abc"，且abc不区分大小写
Person.objects.filter(name__regex="^abc")   # 正则表达式查询
Person.objects.filter(name__iregex="^abc")  # 正则表达式不区分大小写

3. exclude
filter是找出满足条件的，当然也有排除符合某条件的
Person.objects.exclude(name__contains="WZ")  # 排除包含 WZ 的Person对象
Person.objects.filter(name__contains="abc").exclude(age=23)  # 找出名称含有abc, 但是排除年龄是23岁的
"""
print DATA;
