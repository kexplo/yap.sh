#!/usr/bin/env bash
# pass os: all
set -euo pipefail

if ! has rg; then
  info "Installing ripgrep..."
  cargo install ripgrep
else
  info "Skipped, ripgrep already installed"
fi
