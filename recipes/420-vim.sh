#!/usr/bin/env bash
set -euo pipefail

function install_vim_dependencies() {
  if is_ubuntu_16_04; then
    local pkgs=(
      lua5.1
      liblua5.1-dev
      luajit
      libluajit-5.1-dev
      ruby-dev
      libperl-dev
      ncurses-dev
      mono-xbuild  # for YouCompleteMe
      libmono-system-xml-linq4.0-cil  # for YouCompleteMe
      libmono-microsoft-csharp4.0-cil  # for YouCompleteMe
      libmono-system-data-datasetextensions4.0-cil  # for YouCompleteMe
      cmake        # for YouCompleteMe
    )
    sudo apt-get install -y "${pkgs[@]}"
  fi
}

function check_vim_installed() {
  version="$1"
  if ! has vim; then
    false
  fi
  vim --version | head -1 | grep -q "Vi IMproved $version"
}

function install_vim () {
  version="$1"

  if check_vim_installed "$version"; then
    echo "Vim $version already installed"
    return
  fi

  version_regex="${version/./\\.}"
  # Clone latest revision of version
  git clone -b "$(git ls-remote --tags https://github.com/vim/vim.git | grep -o "v${version_regex}"'\.[0-9]\+' | tail -1)" --depth 1 https://github.com/vim/vim.git /tmp/vim
  pushd '/tmp/vim'
    install_vim_dependencies

    # NOTE: If both python2.x and python3.x are enabled then the linking will be via dlopen(), dlsym(), dlclose().
    # SEE: https://github.com/vim/vim/blob/master/src/Makefile#L444-L445
    ./configure --with-features=huge \
      --enable-multibyte \
      --enable-rubyinterp=yes \
      --enable-pythoninterp=yes \
      --with-python-command=/usr/bin/python2 \
      --enable-perlinterp=dynamic \
      --enable-luainterp=yes \
      --with-luajit \
      --enable-cscope \
      --enable-fail-if-missing \
      --prefix=/usr/local
    # --enable-python3interp=yes \
    # --with-python3-command=/usr/bin/python3 \
    sudo make install
  popd
  sudo rm -rf /tmp/vim
}

function install_vim_ycm() {
  pushd "$HOME/.vim/plugged/YouCompleteMe"
   python ./install.py --cs-completer --clang-completer 
  popd
}

function install_vim_plugins() {
  if [ ! -f "$HOME/.vim/autoload/plug.vim" ]
  then
    info "Installing Vim-Plug..."
    curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  fi

  local prev_ycm_version=""
  if [ -d "$HOME/.vim/plugged/YouCompleteMe" ]; then
    prev_ycm_version=$(git -C "$HOME/.vim/plugged/YouCompleteMe" rev-parse --short HEAD)
  fi

  info "Installing Vim plugins..."
  vim +PlugUpdate +qall

  local new_ycm_version
  new_ycm_version=$(git -C "$HOME/.vim/plugged/YouCompleteMe" rev-parse --short HEAD)
  if [[ "$prev_ycm_version" != "$new_ycm_version" ]]; then
    install_vim_ycm
  fi
}

function install_vi_symbolic_link() {
  sudo ln -fs $(which vim) /usr/bin/vi
}

install_vim 8.1
install_vi_symbolic_link
install_vim_plugins
