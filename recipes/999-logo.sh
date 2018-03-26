#!/usr/bin/env bash

# Show funny logo.
info '
  _  _  __   ____  _   
 ( \/ )/ _\ (  _ \/ \   
  )  //    \ ) __/\_/   
 (__/ \_/\_/(__)  (_)   
'

info "Terraformed successfully by yap.sh."
if [[ -d "$BACKUP_DIR" ]]; then
  info "Backup files are stored in $BACKUP_DIR"
fi
if [[ $SHELL != $(which zsh) && -z $ZSH ]]; then
  info "To use terraformed ZSH, relogin or"
  echo
  info "  $ zsh"
  echo
fi
