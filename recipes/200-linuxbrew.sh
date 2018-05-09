#!/usr/bin/env bash

if [[ "$(uname -s)" == "Linux" ]]; then
  # Install usefual utilities.
  info "Installing linuxbrew...."
  yes | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
  PATH="$HOME/.linuxbrew/bin:$PATH"
fi
