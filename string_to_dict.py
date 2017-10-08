
def dictitem(s):
    t = s.split('=', 1)
    if len(t) > 1:
        return (t[0].lower(), t[1])
    else:
        return (t[0].lower(), True)

cc=["aa=aa_value", "bb=bb_value", "cc=cc_value", "dd=dd_value"];
cc = dict(dictitem(el) for el in cc)
print(cc);

