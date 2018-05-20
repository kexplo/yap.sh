#!/usr/bin/env bash

function install_vim () {
  if is_ubuntu_16_04; then
    local pkgs=(
      vim
      vim-nox-py2
      mono-xbuild  # for YouCompleteMe
      cmake        # for YouCompleteMe
    )
    sudo apt-get install -y "${pkgs[@]}"
  fi
}


install_vim

if [ ! -f ~/.vim/autoload/plug.vim ]
then
  info "Installing Vim-Plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

info "Installing Vim plugins..."
vim +PlugInstall +qall
