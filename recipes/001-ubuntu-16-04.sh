#!/usr/bin/env bash

is_ubuntu_16_04 () {
  if [ -f '/etc/os-release' ]; then
    # shellcheck disable=SC1091
    source '/etc/os-release'
    if [[ "$NAME" != "Ubuntu" ]]; then
      false
    fi
    if [[ "$VERSION_ID" != "16.04" ]]; then
      false
    fi
    true
  fi
  false
}

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
  info "Skipped"
fi
