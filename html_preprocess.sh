#!/bin/bash
#2010_07_29_18:18:22 add by qzj
html=$1
echo $html
#sed -i 's/\<\//\n\<\//g'  $html
#stytle ��Ҫ������ , ����������html ���� </head> �ı�Ƕ�ʧ��������ʾ�������ر�ÿ��� �� //bin/get_html_in_body.pl ��ʱ�� Ч�������ر�á� 
#sed -i 's/<\//\n<\//g' $html
sed -i 's/<\//\n<\//g' $html
