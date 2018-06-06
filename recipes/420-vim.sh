#!/usr/bin/env bash

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
      cmake        # for YouCompleteMe
    )
    sudo apt-get install -y "${pkgs[@]}"
  fi
}

function install_vim () {
  version="$1"
  version_regex="${version/./\\.}"
  # Clone latest revision of version
  git clone -b "$(git ls-remote --tags https://github.com/vim/vim.git | grep -o "v${version_regex}"'\.[0-9]\+' | tail -1)" --depth 1 https://github.com/vim/vim.git /tmp/vim
  cd '/tmp/vim'
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
  sudo rm -rf /tmp/vim
}

install_vim 8.1

if [ ! -f ~/.vim/autoload/plug.vim ]
then
  info "Installing Vim-Plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

info "Installing Vim plugins..."
vim +PlugInstall +qall
