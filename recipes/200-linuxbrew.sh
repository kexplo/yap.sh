#!/usr/bin/env bash

if ! has brew; then
  if [[ "$(uname -s)" == "Linux" ]]; then
    info "Installing linuxbrew...."

    # Set Linuxbrew's variables to prevent install failing
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

    set +o pipefail  # prevent to failing yap.sh
    yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    set -o pipefail
  fi
else
  info "Skipped, Linuxbrew already installed"
fi
