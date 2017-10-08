# -*- coding:utf-8 -*-
from __future__ import with_statement
import sys
import os

def map2idc(in_file, out_file):
    with open(out_file, 'w') as fout:
        fout.write('#include <idc.idc>\n')
        fout.write('static main()\n{\n')
        with open(in_file) as fin:
            for line in fin:
                list = line.split()
                if len(list) >= 3 and len(str(list[2])) == 8 and str(list[2]).isalnum():
                    fout.write('\tMakeName(0x%s, "%s");\n' % (list[2], list[1]))
        fout.write('}\n')

def main():
    from optparse import OptionParser
    parser = OptionParser(usage='usage: %prog <map filename>')
    (options, args) = parser.parse_args()
    if len(args) < 1:
        parser.error('incorrect number of arguments')
    return map2idc(args[0], os.path.splitext(args[0])[0]+'.idc')

if __name__=="__main__":
    sys.exit(main())
