#!/usr/bin/env bash
set -euo pipefail

# if is_ubuntu_16_04; then
#   sudo apt-get install -y tmux
# fi

function install_tmux_dependencies() {
  if is_ubuntu_16_04; then
    local pkgs=(
      automake
      build-essential
      pkg-config
      libevent-dev
      libncurses5-dev
    )
    sudo apt-get install -y "${pkgs[@]}"
  fi
}

function check_tmux_installed() {
  version="$1"
  if ! has tmux; then
    false
  fi
  tmux -V | grep -q "tmux $version"
}

function install_tmux() {
  local version="$1"

  if check_tmux_installed "$version"; then
    echo "tmux $version already installed"
    return
  fi

  mkdir -p /tmp/tmux
  wget -qO- "https://github.com/tmux/tmux/releases/download/${version}/tmux-${version}.tar.gz" | tar xvz -C /tmp/tmux
  pushd /tmp/tmux/tmux*
   ./configure
   make
   sudo make install
  popd
  rm -rf /tmp/tmux
}

install_tmux_dependencies
install_tmux 2.7

info "Installing tpm"
github_repo tmux-plugins/tpm ~/.tmux/plugins/tpm


# Install tmux plugin ( https://github.com/tmux-plugins/tpm/issues/6 )
info "Installing tmux plugins..."
# start a server but don't attach to it
tmux start-server
# create a new session but don't attach to it either
tmux new-session -d
# install the plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh
# killing the server is not required, I guess
tmux kill-server
