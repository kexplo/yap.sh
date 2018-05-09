#!/usr/bin/env bash

info "Setting up the Zsh environment..."

sudo chsh -s "$(which zsh)" "$USER"

github_repo robbyrussell/oh-my-zsh ~/.oh-my-zsh
github_repo zsh-users/zsh-syntax-highlighting \
         ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
github_repo zsh-users/zsh-autosuggestions \
         ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
github_repo bobthecow/git-flow-completion \
         ~/.oh-my-zsh/custom/plugins/git-flow-completion
