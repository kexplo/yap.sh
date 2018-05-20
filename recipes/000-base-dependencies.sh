#!/usr/bin/env bash

if is_ubuntu_16_04; then

  readonly APT_PKGS=(
    aptitude
    build-essential
    curl
    git
    git-flow
    htop
    vim
    vim-nox-py2
    mono-xbuild  # for YouCompleteMe
    cmake        # for YouCompleteMe
    zsh
    tmux
    gawk         # Fix zplug update raises unknown error, SEE: https://github.com/zplug/zplug/issues/359#issuecomment-349534715
   )

  sudo apt-get update
  sudo apt-get install -y "${APT_PKGS[@]}"
elif is_osx; then
  xcode-select --install
  # install brew without prompt
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
else
  info "Skipped: $(get_os_type)"
fi
