#!/usr/bin/env bash

if is_ubuntu_16_04; then
  # ubuntu 16.04 docker image doesn't have sudo command
  if ! which sudo >/dev/null; then
    apt update
    apt install -y sudo
  fi

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

  sudo apt install -y "${APT_PKGS[@]}"
else
  info "Skipped: $(get_os_type)"
fi
