#!/usr/bin/env bash

readonly RC_REPO="$HOME/rc"

# Symbolic links config files.
info "Linking dot files from kexplo/rc..."

github_repo kexplo/rc.git "$RC_REPO"
sym_link "$RC_REPO/stdlib.sh" "$HOME/stdlib.sh"
sym_link "$RC_REPO/.vimrc" "$HOME/.vimrc"
sym_link "$RC_REPO/.zshrc" "$HOME/.zshrc"
sym_link "$RC_REPO/.gitconfig" "$HOME/.gitconfig"
sym_link "$RC_REPO/.tmux.conf" "$HOME/.tmux.conf"
