#!/usr/bin/env bash
# skip os: ubuntu 16.04
# skip os: ubuntu 18.04

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

if ! has brew; then
  if [[ "$(uname -s)" == "Linux" ]]; then
    info "Installing linuxbrew...."

    set +o pipefail  # prevent to failing yap.sh
    yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
    set -o pipefail
  fi
else
  info "Skipped, Linuxbrew already installed"
fi
