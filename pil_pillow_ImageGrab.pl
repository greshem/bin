#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

#Pillow, a replacement for PIL, 
#Use `from PIL import Image` instead of `import Image`.

https://github.com/python-pillow/Pillow
http://www.lfd.uci.edu/~gohlke/pythonlibs/
http://www.lfd.uci.edu/~gohlke/pythonlibs/th4jbnf9/Pillow-3.2.0-cp27-cp27m-win_amd64.whl

G:\sdb1\_xfile\2016_all_iso\_xfile_2016_04\Pillow-3.2.0-cp27-cp27m-win_amd64.whl


import PIL
from PIL import Image,ImageGrab
im = ImageGrab.grab()

im.save("d:\sketch.png")
