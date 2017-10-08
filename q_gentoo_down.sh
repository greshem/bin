for each in $(cat /root/linux_src/1gentoo.txt ); do  axel http://gentoo.osuosl.org/distfiles/$each; done
