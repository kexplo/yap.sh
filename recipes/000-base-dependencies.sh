#!/usr/bin/env bash
set -euo pipefail

if is_ubuntu_16_04; then

  readonly apt_pkgs=(
    aptitude
    build-essential
    curl
    git
    git-flow
    htop
    zsh
    gawk         # Fix zplug update raises unknown error, SEE: https://github.com/zplug/zplug/issues/359#issuecomment-349534715
   )

  sudo apt-get update
  sudo apt-get install -y "${apt_pkgs[@]}"
elif is_osx; then
  xcode-select --install
  # install brew without prompt
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" < /dev/null
else
  info "Skipped: $(get_os_type)"
fi
