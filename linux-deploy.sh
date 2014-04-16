#!/bin/bash

cp -r dot.vim ~/.vim
cp dot.vimrc ~/.vimrc
cp dot.vimrc-lang-remap ~/.vimrc-lang-remap

echo "installin vundle"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

echo "installing vundle plugins"
vim +PluginInstall +qall
