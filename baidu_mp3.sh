 
#!/bin/bash
#Copyright (c) 2006 bones7456 (bones7456@gmail.com)
#License: GPLv2
#�ǳ���лubuntu������oneleaf����
#ǿ�ҽ��鰲װaxel�����߳����ع��ߣ���mid3v2��������python-mutagen������޸ĸ�����id3��Ϣ��

#����mp3��Ŀ¼���������Ҫ�޸ġ�
SAVE="${HOME}/baidump3"
#SAVE="${HOME}/oldsong"

#mp3�ĵ�ַ
#�¸�TOP100
#SOURCE="http://list.mp3.baidu.com/list/newhits.html"
#����top500
#SOURCE="http://list.mp3.baidu.com/topso/mp3topsong.html"
#�����ϸ�
#SOURCE="http://list.mp3.baidu.com/list/oldsong.html"
#��Ӱ����
#SOURCE="http://list.mp3.baidu.com/list/movies.html"
#��辫ѡ
#SOURCE="http://list.mp3.baidu.com/minge/mp3topsong.html"
#У԰����
#SOURCE="http://list.mp3.baidu.com/xiaoyuan/mp3topsong.html"
#������
#SOURCE="http://list.mp3.baidu.com/list/qingyinyue.html"
#�ٶ�����
SOURCE="http://list.mp3.baidu.com/list/shaoergequ.html"
#ҡ��������
#SOURCE="http://list.mp3.baidu.com/list/yaogun.html"
#��������
#SOURCE="http://list.mp3.baidu.com/list/liujinsuiyue.html"


#�������Դ���
TRYCOUNT=2

#��axel����ʱ���߳���
AXELNUM=7

#��ʱĿ¼
TMP="/tmp/baidump3-${USER}2"

#�Ƿ���Ҫ��ͣ
PAUSE=0

if [ x`which axel` = x"" ];then
PAUSE=1
cat << EOF
����ϵͳ��û�а�װaxel���߳����ع��ߣ��⽫����ֻ��ʹ��wget���е��߳����أ�����Ӱ�������ٶȡ�
�����ubuntu�û�������ֱ��ʹ�� sudo apt-get install axel ���а�װ������ϵͳ�����axel��ҳ��http://wilmer.gaast.net/main.php/axel.html �������ء���װ��

EOF
fi
if [ x`which mid3v2` = x"" ];then
PAUSE=1
cat << EOF
����ϵͳ��û�а�װmid3v2���ߣ�ʹ�øù��߿����޸�mp3�����ı�ǩ��Ϣ(����֡�������)����ȥ�����ܰ��������еĹ����Ϣ��
�����ubuntu�û�������ֱ��ʹ�� sudo apt-get install python-mutagen ���а�װ������ϵͳ���������ҳ��http://www.sacredchao.net/quodlibet/wiki/Development/Mutagen �������ء���װ��

EOF
fi
if [ "$PAUSE" = 1 ];then
 echo "�Ƿ����(y|n)��"
 read KEYVAR
 case "$KEYVAR" in
 "Y" | "y" )
 echo �Թ���
 ;;
 * )
 exit 0
 ;;
 esac
fi

#��������Ŀ¼
if [ ! -d "${SAVE}" ];then
    mkdir -p "${SAVE}"
fi

#������ʱ����Ŀ¼
if [ -d "${TMP}" ];then
 rm -rf "${TMP}"
fi
    mkdir -p "${TMP}"

echo "��ʼ���ذٶ�����100�׸����б�"
wget -O ${TMP}/mp3.html ${SOURCE}
echo "���ذٶ�����100�׸����б���ɡ�"

#ת����ҳ����
iconv -f gbk -t utf8 ${TMP}/mp3.html |\

grep " href=\"http://mp3.baidu.com/m" |\

#��mp3list.txt���п�ͷ�Ŀո�ȥ��
sed -e 's/ *//' |\

#��mp3list.txt���п�ͷ��tabȥ��
sed -e 's/\t*//' |\

#��mp3list.txt����ȫ�ǿո�ȥ��
sed -e 's/��//g' |\

#�����еĻس���ȥ��
sed ':a;N;$!ba;s/\n/,/g' |\

#��td>,������ϻس�����һ�б�ʾһ��mp3�ļ���
sed -e 's/,<td/\n<td/g' |\
sed -e 's/td>,/td>\n/g' |\

#ɾ��<td width="30%"> <td> </td> <td...FFFFFF"> <p> </p>
sed -e 's/<td width="30%">//g' |\
sed -e 's/<td>//g' |\
sed -e 's/<\/td>//g' |\
sed -e 's/<p>//g' |\
sed -e 's/<\/p>//g' |\
sed -e 's/<td.*"border">//g' |\

#ɾ��</a>..."_blank">
sed -e 's/<\/A>\/<A.*_blank>/��/g' |\
sed -e 's/<\/A>/<\/a>/g' |\
sed -e 's/<\/a>.*_blank>/-/g' |\
#sed -e 's/<\/a>.*_blank">/-/g' |\
#ɾ��)
sed -e 's/<\/a>)/<\/a>/g' |\

#ɾ��&amp;
sed -e 's/\&amp\;/\//g' >${TMP}/mp3list.txt

#�õ���<a href="http://mp3.baidu.com/m?tn=baidump3&ct= 134217728&lm=-1&li=2&word=Baby%20Baby%20tell%20me%20%CD%F5%D0% C4%C1%E8" target="_blank">Baby ,Baby tell me-������</a>

#ȡ���кţ�ѭ��
line=$(awk 'END{print NR}' ${TMP}/mp3list.txt)
i=1;
while((i<=line));do
   downed=0;
   mpline=`awk 'NR=='"$i"'' ${TMP}/mp3list.txt`
   url=`echo $mpline | sed -e 's/<a href="//g' | sed 's/\ target.*//g' | sed 's/"//g' | cat`
   name=`echo $mpline | sed -e 's/.*_blank">//g' | sed -e 's/.*_blank>//g' |\
        sed -e 's/<\/a>//g' | sed -e 's/\//-/g' | sed -e 's/:/-/g'  | sed -e 's/"/'\''/g'  | cat`
 
   #����Ƿ��Ѿ����ع����׸裬������ع�������
   if [ -e "${SAVE}/${name}.mp3" ] || [ -e "${SAVE}/${name}.wma" ]; then
      echo -e "\e[1;6m\e[1;31m���� ${name} ���ع������ԣ�������һ�ס�\e[1;6m\e[00m"
      ((i++))
      continue;
   fi

   echo "��ʼͨ�� $url ���� $name";
   wget -O ${TMP}/down.html $url
   echo "��ȡ $name �����б���ɡ�";

   #down.txtΪ��Ч�����ص�ַ
   iconv -f gbk -t utf8 -c ${TMP}/down.html | grep "onclick=\"return ow(event,this)\"" |\
   sed -e 's/.*<a href="//g' | sed -e 's/" target="_blank".*//g' > ${TMP}/down.txt

   #size.txtΪ��Ч�������ļ���С
   iconv -f gbk -t utf8 -c ${TMP}/down.html | grep "M<\/td>" |\
   sed -e 's/<td>//g' | sed -e 's/ M<\/td>//g' > ${TMP}/size.txt

   #down.txt��size.txt�ϲ����ڵ�down_size.txt�ļ����ֶ�֮����"`"��Ϊ�ָ���
   paste -d '`' ${TMP}/size.txt ${TMP}/down.txt > ${TMP}/down_size.txt

   #����
   sort -n -r ${TMP}/down_size.txt > ${TMP}/down_size_sort.txt

   #ȥ������ĳߴ�
   sed 's/.*`//' ${TMP}/down_size_sort.txt > ${TMP}/temp.txt
   sed 's/\" title.*<\/td>//g' ${TMP}/temp.txt > ${TMP}/temp2.txt
        sed 's/ //g' ${TMP}/temp2.txt > ${TMP}/temp.txt
   ##### ��ȡ��mp3 �����ص�ַ�� wma�����ص�ַ ##############
   grep -i "=mp3" ${TMP}/temp.txt > ${TMP}/down_mp3.txt
   grep -i "=wma" ${TMP}/temp.txt > ${TMP}/down_wma.txt



   downline_mp3=$(awk 'END{print NR}' ${TMP}/down_mp3.txt);
   downline_wma=$(awk 'END{print NR}' ${TMP}/down_wma.txt);
   echo -e "\e[1;6m\e[1;31m���� ${downline_mp3} ����Ϊ ${name}.mp3 ���ص�ַ��\e[1;6m\e[00m"
   echo -e "\e[1;6m\e[1;31m���� ${downline_wma} ����Ϊ ${name}.wma ���ص�ַ��\e[1;6m\e[00m"
   # ��ʼ��������
   j=1;
   # ��������mp3��ʽ�ĸ���
   while((j<=downline_mp3)); do
      mp3=`awk 'NR=='"$j"'' ${TMP}/down_mp3.txt | sed -e 's/ /\\ /g'`
      echo -e "\e[1;6m\e[1;31m��������${name}.mp3\e[1;6m\e[00m"
      echo -e "\e[1;6m\e[1;31m��תҳ���ַΪ${mp3}\e[1;6m\e[00m"
      wget -O "${TMP}/transit.html" $mp3
      realURL=`iconv -f gbk -t utf8 -c ${TMP}/transit.html | grep "<li class=\"li\" style=\"margin-right:10px;\">" | sed 's/.*href="//' | sed 's/" target="_blank">.*//'`
      #echo -e "\e[1;6m\e[1;31m��ʵ���ص�ַΪ${realURL}\e[1;6m\e[00m"
      if [ x`which axel` != x"" ];then
   axel -n $AXELNUM -a -o "${TMP}/${name}.mp3" "${realURL}"
   else
   #wget̫���ˡ��������û�а�װaxel,���԰�����һ��ע�͵���������һ�д���
      wget -c --tries=$TRYCOUNT $realURL -O "${TMP}/${name}.mp3"
      fi
      if [ "$?" = 0 ]; then
         if [ `file -ib "${TMP}/${name}.mp3" | sed -e 's/\/.*//g'` = "audio" ]; then
          if [ x`which mid3v2` != x"" ];then
    title=`echo $name | sed -e 's/-.*//g'`
    artist=`echo $name | sed -e 's/.*-//g' | sed -e 's/.mp3//g' | sed -e 's/.wma//g'`
    mid3v2 -D "${TMP}/${name}.mp3"
    mid3v2 -t "${title}" -a "${artist}" "${TMP}/${name}.mp3"
    fi
            mv "${TMP}/${name}.mp3" "${SAVE}/${name}.mp3"
            downed=1;
            break;
         else
            echo -e "\e[1;6m\e[1;31m���� ${name}.mp3 �ļ���Ч������ɾ����������\e[1;6m\e[00m"
            rm "${TMP}/${name}.mp3";
            ((j++))  
         fi
      else
         echo -e "\e[1;6m\e[1;31m���� ${name}.mp3 �ļ���Ч������ɾ����������\e[1;6m\e[00m"
         rm "${TMP}/${name}.mp3";
         ((j++))
      fi
   done

   #������سɹ�����������ĸ�
   #continue��������ѭ�����еĺ�������
   if [ "$downed" = 1 ] ; then
      ((i++))
      echo -e "\e[1;7m\e[1;41m���� $name �ɹ�\e[1;7m\e[00m"
      continue;
   fi

   # ���û��mp3��ʽ��������wma��ʽ�ĸ�
   j=1;
   while((j<=downline_wma)); do
      wma=`awk 'NR=='"$j"'' ${TMP}/down_wma.txt`
      echo -e "\e[1;6m\e[1;31m��������${name}.wma\e[1;6m\e[00m"

      #echo -e "\e[1;6m\e[1;31m��תҳ���ַΪ${mp3}\e[1;6m\e[00m"
      wget -O "${TMP}/transit.html" "$wma"
      realURL=`iconv -f gbk -t utf8 -c ${TMP}/transit.html | grep "<li class=\"li\" style=\"margin-right:10px;\">" | sed 's/.*href="//' | sed 's/" target="_blank">.*//'`
      #echo -e "\e[1;6m\e[1;31m��ʵ���ص�ַΪ${realURL}\e[1;6m\e[00m"
      if [ x`which axel` != x"" ];then
   axel -n $AXELNUM -a -o "${TMP}/${name}.wma" "${realURL}"
   else
   #wget̫���ˡ��������û�а�װaxel,���԰�����һ��ע�͵���������һ�д���
      wget -c --tries=$TRYCOUNT $realURL -O "${TMP}/${name}.wma"
      fi
      if [ "$?" = 0 ]; then
         if [ `file -ib "${TMP}/${name}.wma" | sed -e 's/\/.*//g'` = "application" ]; then
   #title=`echo $name | sed -e 's/-.*//g'`
   #artist=`echo $name | sed -e 's/.*-//g' | sed -e 's/.mp3//g' | sed -e 's/.wma//g'`
   #mid3v2 -D "${TMP}/${name}.wma"
   #mid3v2 -t "${title}" -a "${artist}" "${TMP}/${name}.wma"
            mv "${TMP}/${name}.wma" "${SAVE}/${name}.wma"
            downed=1;
            break;
         else
            echo -e "\e[1;6m\e[1;31m���� ${name}.wma �ļ���Ч������ɾ����������\e[1;6m\e[00m"
            rm "${TMP}/${name}.wma";
            ((j++))  
         fi
      else
          echo -e "\e[1;6m\e[1;31m���� ${name}.wma �ļ���Ч������ɾ����������\e[1;6m\e[00m"
          rm "${TMP}/${name}.wma";
          ((j++))
      fi
   done

   ((i++))
   if [ "$downed" = 1 ] ; then
      echo -e "\e[1;7m\e[1;41m���� $name �ɹ�\e[1;7m\e[00m"
   else
      echo -e "\e[1;7m\e[1;41m���� $name ʧ��\e[1;7m\e[00m"
   fi
done
rm -fr ${TMP}
exit 0
