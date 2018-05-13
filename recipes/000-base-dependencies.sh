#!/usr/bin/env bash

if is_ubuntu_16_04; then

  readonly APT_PKGS=(
    aptitude
    curl
    git
    git-flow
    htop
    python2.7
    vim
    vim-nox-py2
    mono-xbuild  # for YouCompleteMe
    cmake        # for YouCompleteMe
    zsh
    tmux
   )

  sudo apt update
  sudo apt install -y "${APT_PKGS[@]}"
elif is_osx; then
  xcode-select --install
  # install brew without prompt
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
else
  info "Skipped: $(get_os_type)"
fi
