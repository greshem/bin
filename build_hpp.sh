cat <<EOF
[OPTIONS]
Auto Index=Yes
Binary TOC=No
Binary Index=Yes
Compatibility=1.1
Compiled file=HTML.chm
Contents file=HTML.hhc
Default topic=index.html
Error log file=ErrorLog.log
Index file=HTML.hhk
Title=HTML
Full-text search=Yes
Display compile progress=Yes
Display compile notes=Yes
Default window=main

[WINDOWS]
main=,"HTML.hhc","HTML.hhk","index.html","index.html",,,,,0x23520,222,0x1046,[10,10,780,560],0xB0000,,,,,,0

[FILES]
EOF
find . -type f  -maxdepth 1 |grep html$
find ./ -type f -maxdepth 2 |grep html$|sort -n
