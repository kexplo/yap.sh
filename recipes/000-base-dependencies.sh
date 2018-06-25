#!/usr/bin/env bash
set -euo pipefail

check_sudo_requires_password() {
  if ! sudo -n true 2>/dev/null; then
    err "sudo without a password is required for run yap.sh"
    echo
    echo "Run the following command to make $USER can use sudo without password:"
    info "  sudo echo '$USER ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/$USER"
    echo
    exit 1
  fi
}

check_sudo_requires_password

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
    wget
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
