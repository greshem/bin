 
#!/bin/bash
#Copyright (c) 2006 bones7456 (bones7456@gmail.com)
#License: GPLv2
#非常感谢ubuntu社区和oneleaf老兄
#强烈建议安装axel（多线程下载工具）和mid3v2（包含在python-mutagen里，用于修改歌曲的id3信息）

#保存mp3的目录，请根据需要修改。
SAVE="${HOME}/baidump3"
#SAVE="${HOME}/oldsong"

#mp3的地址
#新歌TOP100
#SOURCE="http://list.mp3.baidu.com/list/newhits.html"
#歌曲top500
#SOURCE="http://list.mp3.baidu.com/topso/mp3topsong.html"
#经典老歌
#SOURCE="http://list.mp3.baidu.com/list/oldsong.html"
#电影金曲
#SOURCE="http://list.mp3.baidu.com/list/movies.html"
#民歌精选
#SOURCE="http://list.mp3.baidu.com/minge/mp3topsong.html"
#校园歌曲
#SOURCE="http://list.mp3.baidu.com/xiaoyuan/mp3topsong.html"
#轻音乐
#SOURCE="http://list.mp3.baidu.com/list/qingyinyue.html"
#少儿歌曲
SOURCE="http://list.mp3.baidu.com/list/shaoergequ.html"
#摇滚歌曲榜
#SOURCE="http://list.mp3.baidu.com/list/yaogun.html"
#流金岁月
#SOURCE="http://list.mp3.baidu.com/list/liujinsuiyue.html"


#下载重试次数
TRYCOUNT=2

#用axel下载时的线程数
AXELNUM=7

#临时目录
TMP="/tmp/baidump3-${USER}2"

#是否需要暂停
PAUSE=0

if [ x`which axel` = x"" ];then
PAUSE=1
cat << EOF
您的系统中没有安装axel多线程下载工具，这将导致只能使用wget进行单线程下载，将会影响下载速度。
如果是ubuntu用户，可以直接使用 sudo apt-get install axel 进行安装，其他系统请访问axel主页：http://wilmer.gaast.net/main.php/axel.html 进行下载、安装。

EOF
fi
if [ x`which mid3v2` = x"" ];then
PAUSE=1
cat << EOF
您的系统中没有安装mid3v2工具，使用该工具可以修改mp3歌曲的标签信息(如歌手、歌名等)，并去掉可能包含于其中的广告信息。
如果是ubuntu用户，可以直接使用 sudo apt-get install python-mutagen 进行安装，其他系统请访问其主页：http://www.sacredchao.net/quodlibet/wiki/Development/Mutagen 进行下载、安装。

EOF
fi
if [ "$PAUSE" = 1 ];then
 echo "是否继续(y|n)？"
 read KEYVAR
 case "$KEYVAR" in
 "Y" | "y" )
 echo 略过。
 ;;
 * )
 exit 0
 ;;
 esac
fi

#创建下载目录
if [ ! -d "${SAVE}" ];then
    mkdir -p "${SAVE}"
fi

#创建临时下载目录
if [ -d "${TMP}" ];then
 rm -rf "${TMP}"
fi
    mkdir -p "${TMP}"

echo "开始下载百度最新100首歌曲列表"
wget -O ${TMP}/mp3.html ${SOURCE}
echo "下载百度最新100首歌曲列表完成。"

#转换网页编码
iconv -f gbk -t utf8 ${TMP}/mp3.html |\

grep " href=\"http://mp3.baidu.com/m" |\

#将mp3list.txt所有开头的空格去掉
sed -e 's/ *//' |\

#将mp3list.txt所有开头的tab去掉
sed -e 's/\t*//' |\

#将mp3list.txt所有全角空格去掉
sed -e 's/　//g' |\

#将所有的回车符去掉
sed ':a;N;$!ba;s/\n/,/g' |\

#在td>,后面加上回车符，一行表示一个mp3文件。
sed -e 's/,<td/\n<td/g' |\
sed -e 's/td>,/td>\n/g' |\

#删除<td width="30%"> <td> </td> <td...FFFFFF"> <p> </p>
sed -e 's/<td width="30%">//g' |\
sed -e 's/<td>//g' |\
sed -e 's/<\/td>//g' |\
sed -e 's/<p>//g' |\
sed -e 's/<\/p>//g' |\
sed -e 's/<td.*"border">//g' |\

#删除</a>..."_blank">
sed -e 's/<\/A>\/<A.*_blank>/、/g' |\
sed -e 's/<\/A>/<\/a>/g' |\
sed -e 's/<\/a>.*_blank>/-/g' |\
#sed -e 's/<\/a>.*_blank">/-/g' |\
#删除)
sed -e 's/<\/a>)/<\/a>/g' |\

#删除&amp;
sed -e 's/\&amp\;/\//g' >${TMP}/mp3list.txt

#得到：<a href="http://mp3.baidu.com/m?tn=baidump3&ct= 134217728&lm=-1&li=2&word=Baby%20Baby%20tell%20me%20%CD%F5%D0% C4%C1%E8" target="_blank">Baby ,Baby tell me-王心凌</a>

#取得行号，循环
line=$(awk 'END{print NR}' ${TMP}/mp3list.txt)
i=1;
while((i<=line));do
   downed=0;
   mpline=`awk 'NR=='"$i"'' ${TMP}/mp3list.txt`
   url=`echo $mpline | sed -e 's/<a href="//g' | sed 's/\ target.*//g' | sed 's/"//g' | cat`
   name=`echo $mpline | sed -e 's/.*_blank">//g' | sed -e 's/.*_blank>//g' |\
        sed -e 's/<\/a>//g' | sed -e 's/\//-/g' | sed -e 's/:/-/g'  | sed -e 's/"/'\''/g'  | cat`
 
   #检查是否已经下载过这首歌，如果下载过，放弃
   if [ -e "${SAVE}/${name}.mp3" ] || [ -e "${SAVE}/${name}.wma" ]; then
      echo -e "\e[1;6m\e[1;31m发现 ${name} 下载过，忽略，继续下一首。\e[1;6m\e[00m"
      ((i++))
      continue;
   fi

   echo "开始通过 $url 下载 $name";
   wget -O ${TMP}/down.html $url
   echo "获取 $name 下载列表完成。";

   #down.txt为有效的下载地址
   iconv -f gbk -t utf8 -c ${TMP}/down.html | grep "onclick=\"return ow(event,this)\"" |\
   sed -e 's/.*<a href="//g' | sed -e 's/" target="_blank".*//g' > ${TMP}/down.txt

   #size.txt为有效的下载文件大小
   iconv -f gbk -t utf8 -c ${TMP}/down.html | grep "M<\/td>" |\
   sed -e 's/<td>//g' | sed -e 's/ M<\/td>//g' > ${TMP}/size.txt

   #down.txt与size.txt合并而在的down_size.txt文件中字段之间以"`"作为分隔符
   paste -d '`' ${TMP}/size.txt ${TMP}/down.txt > ${TMP}/down_size.txt

   #排序
   sort -n -r ${TMP}/down_size.txt > ${TMP}/down_size_sort.txt

   #去掉后面的尺寸
   sed 's/.*`//' ${TMP}/down_size_sort.txt > ${TMP}/temp.txt
   sed 's/\" title.*<\/td>//g' ${TMP}/temp.txt > ${TMP}/temp2.txt
        sed 's/ //g' ${TMP}/temp2.txt > ${TMP}/temp.txt
   ##### 析取出mp3 的下载地址或 wma的下载地址 ##############
   grep -i "=mp3" ${TMP}/temp.txt > ${TMP}/down_mp3.txt
   grep -i "=wma" ${TMP}/temp.txt > ${TMP}/down_wma.txt



   downline_mp3=$(awk 'END{print NR}' ${TMP}/down_mp3.txt);
   downline_wma=$(awk 'END{print NR}' ${TMP}/down_wma.txt);
   echo -e "\e[1;6m\e[1;31m发现 ${downline_mp3} 个名为 ${name}.mp3 下载地址。\e[1;6m\e[00m"
   echo -e "\e[1;6m\e[1;31m发现 ${downline_wma} 个名为 ${name}.wma 下载地址。\e[1;6m\e[00m"
   # 初始化计数器
   j=1;
   # 优先下载mp3格式的歌曲
   while((j<=downline_mp3)); do
      mp3=`awk 'NR=='"$j"'' ${TMP}/down_mp3.txt | sed -e 's/ /\\ /g'`
      echo -e "\e[1;6m\e[1;31m正在下载${name}.mp3\e[1;6m\e[00m"
      echo -e "\e[1;6m\e[1;31m中转页面地址为${mp3}\e[1;6m\e[00m"
      wget -O "${TMP}/transit.html" $mp3
      realURL=`iconv -f gbk -t utf8 -c ${TMP}/transit.html | grep "<li class=\"li\" style=\"margin-right:10px;\">" | sed 's/.*href="//' | sed 's/" target="_blank">.*//'`
      #echo -e "\e[1;6m\e[1;31m真实下载地址为${realURL}\e[1;6m\e[00m"
      if [ x`which axel` != x"" ];then
   axel -n $AXELNUM -a -o "${TMP}/${name}.mp3" "${realURL}"
   else
   #wget太慢了。但是如果没有安装axel,可以把上面一行注释掉，用下面一行代替
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
            echo -e "\e[1;6m\e[1;31m下载 ${name}.mp3 文件无效，正在删除重新下载\e[1;6m\e[00m"
            rm "${TMP}/${name}.mp3";
            ((j++))  
         fi
      else
         echo -e "\e[1;6m\e[1;31m下载 ${name}.mp3 文件无效，正在删除重新下载\e[1;6m\e[00m"
         rm "${TMP}/${name}.mp3";
         ((j++))
      fi
   done

   #如果下载成功继续下其余的歌
   #continue用于跳过循环体中的后续命令
   if [ "$downed" = 1 ] ; then
      ((i++))
      echo -e "\e[1;7m\e[1;41m下载 $name 成功\e[1;7m\e[00m"
      continue;
   fi

   # 如果没有mp3格式的则下载wma格式的歌
   j=1;
   while((j<=downline_wma)); do
      wma=`awk 'NR=='"$j"'' ${TMP}/down_wma.txt`
      echo -e "\e[1;6m\e[1;31m正在下载${name}.wma\e[1;6m\e[00m"

      #echo -e "\e[1;6m\e[1;31m中转页面地址为${mp3}\e[1;6m\e[00m"
      wget -O "${TMP}/transit.html" "$wma"
      realURL=`iconv -f gbk -t utf8 -c ${TMP}/transit.html | grep "<li class=\"li\" style=\"margin-right:10px;\">" | sed 's/.*href="//' | sed 's/" target="_blank">.*//'`
      #echo -e "\e[1;6m\e[1;31m真实下载地址为${realURL}\e[1;6m\e[00m"
      if [ x`which axel` != x"" ];then
   axel -n $AXELNUM -a -o "${TMP}/${name}.wma" "${realURL}"
   else
   #wget太慢了。但是如果没有安装axel,可以把上面一行注释掉，用下面一行代替
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
            echo -e "\e[1;6m\e[1;31m下载 ${name}.wma 文件无效，正在删除重新下载\e[1;6m\e[00m"
            rm "${TMP}/${name}.wma";
            ((j++))  
         fi
      else
          echo -e "\e[1;6m\e[1;31m下载 ${name}.wma 文件无效，正在删除重新下载\e[1;6m\e[00m"
          rm "${TMP}/${name}.wma";
          ((j++))
      fi
   done

   ((i++))
   if [ "$downed" = 1 ] ; then
      echo -e "\e[1;7m\e[1;41m下载 $name 成功\e[1;7m\e[00m"
   else
      echo -e "\e[1;7m\e[1;41m下载 $name 失败\e[1;7m\e[00m"
   fi
done
rm -fr ${TMP}
exit 0
