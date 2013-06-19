#!/bin/bash
set -e
if [[ "$1" == ""  ]];then
    echo "--prefix is needed!"
    exit
fi
wget ftp://ftp.vim.org/pub/vim/unix/vim-7.3.tar.bz2
wget ftp://ftp.jp.vim.org/pub/vim/extra/vim-7.2-extra.tar.gz
wget ftp://ftp.vim.org/pub/vim/extra/vim-7.2-lang.tar.gz
tar jxvf vim-7.3.tar.bz2
tar zxvf vim-7.2-lang.tar.gz
mv vim72 vim73
cd vim73/
cd src
./configure --help
make distclean
./configure --prefix=$1 --enable-multibyte
make
make install
echo "alias vim=$1/bin/vim " >~/.vimrc
