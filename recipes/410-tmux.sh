#!/usr/bin/env bash
set -euo pipefail

if is_ubuntu_16_04; then
  sudo apt-get install -y tmux
fi

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
