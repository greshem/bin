#!/bin/sh
mkisofs -o $1.iso  -J -R -A -V -v $1 
