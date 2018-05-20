#!/usr/bin/env bash

if ! has rg; then
  info "Installing ripgrep..."
  cargo install ripgrep
else
  info "Skipped, ripgrep already installed"
fi
