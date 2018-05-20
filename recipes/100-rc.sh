#!/usr/bin/env bash

readonly rc_repo="$HOME/rc"

# Symbolic links config files.
info "Linking dot files from kexplo/rc..."

github_repo kexplo/rc.git "$rc_repo"
sym_link "$rc_repo/stdlib.sh" "$HOME/stdlib.sh"
sym_link "$rc_repo/.vimrc" "$HOME/.vimrc"
sym_link "$rc_repo/.zshrc" "$HOME/.zshrc"
sym_link "$rc_repo/.gitconfig" "$HOME/.gitconfig"
sym_link "$rc_repo/.tmux.conf" "$HOME/.tmux.conf"
