#!/usr/bin/env bash

if ! has cargo; then
  info "Installing cargo..."
  curl -sSf https://static.rust-lang.org/rustup.sh | sh
else
  info "Skipped, cargo already installed"
fi

export PATH="$HOME/.cargo/bin:$PATH"
