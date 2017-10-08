#!/usr/bin/python 
def chomp(line):
    if line[-1] == '\n':
        line = line[:-1]
    return line;


def get_block(input_file):
    inblock=True
    ret=[]
    tmp_block=[];
    for line in open(input_file).readlines():
        if line.isspace():
            if len(tmp_block) != 0:
                ret.append(tmp_block);
                tmp_block=[];
        else:
            tmp_block.append(chomp(line))
    ret.append(tmp_block);
    return ret;
