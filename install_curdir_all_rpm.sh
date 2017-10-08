#!/bin/bash
for each in $(find . -type f -name \*.rpm)
do
echo rpm -ivh --nodeps --force $each
done
