#!/usr/bin/env bash
# pass os: all
set -euo pipefail

info "Installing facebook's PathPicker(fpp)..."
brew_inst fpp

# fix YCM import error.
# SEE: https://github.com/Valloric/YouCompleteMe/issues/2883
if brew ls --versions 'python@2' >/dev/null; then
  brew uninstall --ignore-dependencies python@2
fi
