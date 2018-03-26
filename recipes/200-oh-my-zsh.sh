#!/usr/bin/env bash

info "Setting up the Zsh environment..."

sudo chsh -s "$(which zsh)" "$USER"

git_repo https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
git_repo https://github.com/zsh-users/zsh-syntax-highlighting \
         ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git_repo https://github.com/zsh-users/zsh-autosuggestions \
         ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git_repo https://github.com/bobthecow/git-flow-completion \
         ~/.oh-my-zsh/custom/plugins/git-flow-completion
