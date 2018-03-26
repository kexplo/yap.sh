#!/usr/bin/env bash

if [ ! -f ~/.vim/autoload/plug.vim ]
then
  info "Installing Vim-Plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

info "Installing Vim plugins..."
vim +PlugInstall +qall
