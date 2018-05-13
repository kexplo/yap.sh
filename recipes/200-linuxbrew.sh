#!/usr/bin/env bash

if [[ "$(uname -s)" == "Linux" ]]; then
  info "Installing linuxbrew...."
  yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
  PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi
