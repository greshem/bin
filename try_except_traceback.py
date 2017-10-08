import  traceback;


def  fun1():
    try:
        open("file_not_exists.txt");
    except  Exception as e:
        print ("Error %s "%e);
        traceback.print_stack();

def fun2():
    fun1();

fun2();
print "success";
