#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}
__DATA__

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

git clone https://github.com/tomtom/tlib_vim.git  ~/.vim/bundle/tlib_vim/
git clone https://github.com/MarcWeber/vim-addon-mw-utils.git  ~/.vim/bundle/vim-addon-mw-utils/
git clone https://github.com/fatih/vim-go.git       ~/.vim/bundle/vim-go/
git clone https://github.com/garbas/vim-snipmate.git  ~/.vim/bundle/vim-snipmate/
git clone https://github.com/honza/vim-snippets.git   ~/.vim/bundle/vim-snippets/


#下面的参数的  有些是必须的 参看
#   https://github.com/garbas/vim-snipmate#installing-snipmate

cat >> ~/.vimrc <<EOF
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'

Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
" Optional:
Plugin 'honza/vim-snippets'


filetype plugin indent on

EOF


#最后执行一下命令, 安装了插件.
echo vim :PluginInstall

