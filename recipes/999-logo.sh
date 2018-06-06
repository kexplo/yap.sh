#!/usr/bin/env bash
# skip os: all

# Show funny logo.
info '
  _  _  __   ____  _   
 ( \/ )/ _\ (  _ \/ \   
  )  //    \ ) __/\_/   
 (__/ \_/\_/(__)  (_)   
'

info "Terraformed successfully by yap.sh."
if [[ -d "$backup_dir" ]]; then
  info "Backup files are stored in $backup_dir"
fi
if [ "$SHELL" != "$(which zsh)" ] && [ "${ZSH:-x}" == "x" ]; then
  info "Now, ZSH is default shell. To use terraformed ZSH, re-login or"
  echo
  info "  $ zsh"
  echo
fi
