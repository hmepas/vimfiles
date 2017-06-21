#!/bin/bash

mkdir ~/.vim
cp -r dot.vim/* ~/.vim
cp dot.vimrc ~/.vimrc
cp dot.vimrc-lang-remap ~/.vimrc-lang-remap
cp perl_incl ~/bin/

echo "installin vundle"
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "installing vundle plugins"
vim +PluginInstall +qall
