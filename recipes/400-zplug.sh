#!/usr/bin/env bash
# pass os: all
set -euo pipefail

info "Setting up the Zsh environment..."

set_zsh_as_default_shell() {
  sudo chsh -s "$(which zsh)" "$USER"
}

install_zplug() {
  github_repo zplug/zplug "$HOME/.zplug"
}

ensure_zplug_plugins() {
  # Ensure the latest zplug plugins installed
  zsh -c "
  source \"$HOME/.zshrc\"
  if ! zplug check; then
    zplug install
  else
    zplug update
  fi
  "
}

set_zsh_as_default_shell
install_zplug
ensure_zplug_plugins

