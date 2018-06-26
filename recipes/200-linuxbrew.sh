#!/usr/bin/env bash
# pass os: ubuntu 16.04
# pass os: ubuntu 18.04
set -euo pipefail

export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

if ! has brew; then
  if [[ "$(uname -s)" == "Linux" ]]; then
    info "Installing linuxbrew...."

    (yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)") || true
  fi
else
  info "Skipped, Linuxbrew already installed"
fi
