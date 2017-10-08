#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

#下面的参数的  有些是必须的 参看
#   https://github.com/garbas/vim-snipmate#installing-snipmate

cat >> ~/.vimrc <<EOF
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
Bundle '其他的 github 位置...'

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
" Optional:
Plugin 'honza/vim-snippets'


filetype plugin indent on

EOF
;


#最后执行一下命令, 安装了插件.
:PluginInstall

