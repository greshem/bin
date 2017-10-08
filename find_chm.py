import glob
from itertools import chain


def find_chm_list(name):
    a = [(line for line in open(fileName).readlines() if name in line and line.endswith("chm\n")) for fileName in glob.glob("/mnt/list_*")]
    b = map(lambda x: "/mnt/" + x,  chain(*a))
    for each in b:
        print(each)


# find_chm_list("hadoop");
if __name__ == '__main__':
    import sys
    if len(sys.argv) != 2:
        print ("Usage: %s  input_name " % sys.argv[0])
        sys.exit(-1)

    name = sys.argv[1]
    find_chm_list(name)
