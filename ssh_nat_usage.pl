#-R 用法
ssh -p6787 -CfNg -R 5901:127.0.0.1:5900 root@mail.emotibot.com.cn   # 本地5900 映射到  mail.emotibot 的 5901 
ssh -p6787 -CfNg -R 5902:127.0.0.1:5900 root@mail.emotibot.com.cn   # 本地5900 映射到  mail.emotibot 的 5902
# socat TCP4-LISTEN:5902,reuseaddr,fork, TCP4:localhost:5901 本机代理一下 所有的都可以范围了. 

#-L 用法.
ssh -p6787 -CfNg -L 5901:127.0.0.1:5901 root@mail.emotibot.com.cn   # mail.emo.. 的 5901  映射到本机. 
ssh -CfNg -L 3128:127.0.0.1:3128   root@teresa #  teresa 的squid  映射到本地.

#==========================================================================
ssh -p 48022 -CfNg -L 4444:127.0.0.1:4444   root@175244.ichengyun.net  # ichengyun 的  4444 端口映射到本地
ssh -p 48022 -CfNg -R 5556:127.0.0.1:22     root@175244.ichengyun.net     # 本地22 映射到  ichengyun 的 5556


