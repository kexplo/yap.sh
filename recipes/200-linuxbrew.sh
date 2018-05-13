#!/usr/bin/env bash

if [[ "$(uname -s)" == "Linux" ]]; then
  info "Installing linuxbrew...."

  # Set Linuxbrew's variables to prevent install failing
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
  export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
  export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"

  yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
fi
