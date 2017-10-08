#!/bin/bash
name=$(basename $(pwd))
find . |cpio -o -c |gzip > ../${name}.img.gz
