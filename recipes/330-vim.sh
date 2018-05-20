#!/usr/bin/env bash

if is_ubuntu_16_04; then
  readonly APT_PKGS=(
    vim
    vim-nox-py2
    mono-xbuild  # for YouCompleteMe
    cmake        # for YouCompleteMe
  )
  sudo apt-get install -y "${APT_PKGS[@]}"
fi

if [ ! -f ~/.vim/autoload/plug.vim ]
then
  info "Installing Vim-Plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

info "Installing Vim plugins..."
vim +PlugInstall +qall
