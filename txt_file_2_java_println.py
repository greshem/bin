
def print_to_java(name):
    fh=open(name);
    for line in fh.readlines():
        def chomp(line):
            if line[-1] == '\n':
                line = line[:-1]
            return line;
        print "System.out.println(\"%s\");"%chomp(line)


if __name__ == '__main__':
    import sys, os
    if len(sys.argv)!=2:
        print "Usage: %s  input_name ";
        sys.exit(-1);
    name=sys.argv[1];
    print_to_java(name);
