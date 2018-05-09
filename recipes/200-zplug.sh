#!/usr/bin/env bash

info "Setting up the Zsh environment..."

set_zsh_as_default_shell() {
  sudo chsh -s "$(which zsh)" "$USER"
}

install_zplug() {
  github_repo zplug/zplug "$HOME/zplug"
}

set_zsh_as_default_shell
install_zplug

# Ensure the latest zplug plugins installed
zsh -i -c "
if ! zplug check; then
  zplug install
else
  zplug update
fi
"
