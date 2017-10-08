#!/usr/bin/python
DATA="""
https://github.com/NetoDevel/cli-spring-boot-scaffold

Workflow
#Workflow generate similar to Rails

#create project
spring init --dependencies=web,data-jpa,thymeleaf,mysql my-project

#create scaffolds
spring scaffold -n "User" -p "name:String email:String"

#create scaffolds for api (Todo)
spring scaffold -n "User" -p "name:String email:String" --api

#create scaffolds reactive (Todo)(version > Spring 5)
spring scaffold -n "User" -p "name:String email:String" --

#create databases
spring db:create -p "mysql"

#migrations (Todo)
spring db:migration

#monitoring (Todo)
spring create:monitoring

"""
print DATA;
