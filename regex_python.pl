
cmprog = re.compile('^@([a-z]+)([ \t]|$)')        # Command (line-oriented)
blprog = re.compile('^[ \t]*$')                   # Blank line
kwprog = re.compile('@[a-z]+')                    # Keyword (embedded, usually
spprog = re.compile('[\n@{}&<>]')                 # Special characters in
miprog = re.compile('^\* ([^:]*):(:|[ \t]*([^\t,\n.]+)([^ \t\n]*))[ \t\n]*')

mo = miprog.match(line)
a, b = mo.span(1)
c, d = mo.span(2)
e, f = mo.span(3)
g, h = mo.span(4)

#print  ret.span(1);
a,b=ret.span(1);
c,d=ret.span(2);

number=line[a:b]
content=line[c:d].encode("gb2312");



mo = spprog.search(text, i)
if mo:
    i = mo.start()



print re.match(r'.* (\d+)', "aa bb cc dd ee 12345").groups()[0]
#返回12345
