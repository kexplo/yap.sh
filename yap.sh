#!/usr/bin/env bash
# vim: set filetype=sh:
#
# yap.sh
# ~~~~~~
#
# Shortest way to terraform a Ubuntu environment as for my taste:
# inspired by sub.sh ( https://github.com/sublee/sub.sh )
#
#  $ curl -sL yap.sh | bash [-s - OPTIONS]
#  $ wget -qO- yap.sh | bash [-s - OPTIONS]
#

set -e; function _ {
TIMESTAMP=$(date +%s)
USER=$(whoami)
RC_REPO=~/rc

# Where some backup files to be stored.
BAK=~/.yap.sh-bak-$TIMESTAMP

# Don't update APT if the last updated time is in a day.
UPDATE_APT_AFTER=86400
APT_UPDATED_AT=~/.yap.sh-apt-updated-at

function help {
  # Print the help message for --help.
  echo "Usage: curl -sL yap.sh | bash [-s - OPTIONS]"
  echo
  echo "Options:"
  echo "  --help              Show this message and exit."
  echo "  --no-apt-update     Do not update APT package lists."
  echo "  --force-apt-update  Update APT package lists on regardless of"
  echo "                      updating period."
}

# Configure options.
APT_UPDATE=auto
for i in "$@"; do
  case $i in
    --help)
      help
      exit;;
    --no-apt-update)
      APT_UPDATE=false
      shift;;
    --force-apt-update)
      APT_UPDATE=true
      shift;;
    *)
      ;;
  esac
done

if [[ -z $TERM ]]; then
  function secho {
    echo "$2"
  }
else
  function secho {
    echo -e "$(tput setaf $1)$2$(tput sgr0)"
  }
fi

function info {
  # Print an information log.
  secho 6 "$1"
}

function err {
  # Print a red colored error message.
  secho 1 "$1"
}

function fatal {
  # Print a red colored error message and exit the script.
  err "$@"
  exit 1
}

function git-pull {
  # Clone a Git repository.  If the repository already exists,
  # just pull from the remote.
  SRC="$1"
  DEST="$2"
  if [[ ! -d "$DEST/.git" ]]; then
    mkdir -p $DEST
    git clone $SRC $DEST
  else
    git -C $DEST pull
  fi
}

function sym-link {
  # Make a symbolic link.  If something should be backed up at
  # the destination path, it moves that to $BAK.
  SRC="$1"
  DEST="$2"
  if [[ -e $DEST || -L $DEST ]]; then
    if [[ "$(readlink -f $SRC)" == "$(readlink -f $DEST)" ]]; then
      return
    fi
    mkdir -p $BAK
    mv $DEST $BAK
  fi
  ln -s $SRC $DEST
}

function failed {
  fatal "Failed to terraform by yap.sh."
}
trap failed ERR

# Go to the home directory.  A current working directory
# may deny access from this user.
cd ~

# Install packages from APT.
if [[ "$APT_UPDATE" != false ]]; then
  APT_UPDATED_BEFORE=$((UPDATE_APT_AFTER + 1))
  if [[ "$APT_UPDATE" == auto && -f $APT_UPDATED_AT ]]; then
    APT_UPDATED_BEFORE=$(($TIMESTAMP - $(cat $APT_UPDATED_AT)))
  fi
  if [[ $APT_UPDATED_BEFORE -gt $UPDATE_APT_AFTER ]]; then
    info "Updating APT package lists..."
    sudo apt-get update
    echo $TIMESTAMP > $APT_UPDATED_AT
  fi
fi
info "Installing packages from APT..."
sudo apt-get install -y ack-grep aptitude curl git git-flow htop ntpdate vim

# Install ZSH and Oh My ZSH!
if [[ ! -x "$(command -v zsh)" ]]; then
  info "Installing Zsh..."
  sudo apt-get install -y zsh
fi
info "Setting up the Zsh environment..."
sudo chsh -s `which zsh` $USER
git-pull https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
git-pull https://github.com/zsh-users/zsh-syntax-highlighting \
         ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
git-pull https://github.com/zsh-users/zsh-autosuggestions \
         ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git-pull https://github.com/bobthecow/git-flow-completion \
         ~/.oh-my-zsh/custom/plugins/git-flow-completion

# Install Vim-Plug for Vim.
info "Setting up the Vim environment..."
# enable python2 support (vim-nox-py2)
# install the requirements for YouCompleteMe (mono-xbuild, cmake)
sudo apt-get install -y vim-nox-py2 mono-xbuild cmake
if [ ! -f ~/.vim/autoload/plug.vim ]
then
  info "Installing vim-plug..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Install tmux
info "Setting up the Tmux environment..."
if [[ ! -x "$(command -v tmux)" ]]; then
  info "Installing Tmux..."
  sudo apt-get install -y tmux
fi
git-pull https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Apply .rc files.
info "Linking dot files from kexplo/rc..."
git-pull https://github.com/kexplo/rc.git $RC_REPO
sym-link $RC_REPO/.vimrc ~/.vimrc
sym-link $RC_REPO/.zshrc ~/.zshrc
sym-link $RC_REPO/.gitconfig ~/.gitconfig
sym-link $RC_REPO/.tmux.conf ~/.tmux.conf
sym-link $RC_REPO/kexplo.zsh-theme ~/.oh-my-zsh/custom/kexplo.zsh-theme

# Install tmux plugin ( https://github.com/tmux-plugins/tpm/issues/6 )
info "Installing tmux plugins..."
# start a server but don't attach to it
tmux start-server
# create a new session but don't attach to it either
tmux new-session -d
# install the plugins
~/.tmux/plugins/tpm/scripts/install_plugins.sh
# killing the server is not required, I guess
tmux kill-server

# Setup a Python environment.
info "Setting up the Python environment..."
sudo apt-get install -y python python-dev python-setuptools python-pip python3-dev
if [[ ! -x "$(command -v virtualenv)" ]]; then
  sudo pip install virtualenv
fi
sudo pip install -U pdbpp

# Install usefual utilities.
info "Installing linuxbrew...."
yes | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install)"
PATH="$HOME/.linuxbrew/bin:$PATH"

info "Installing facebook's PathPicker(fpp)..."
brew install fpp

info "Installing cargo..."
curl -sSf https://static.rust-lang.org/rustup.sh | sh

info "Installing ripgrep..."
cargo install ripgrep

# Show funny logo.
info "
  _  _  __   ____  _   
 ( \/ )/ _\ (  _ \/ \   
  )  //    \ ) __/\_/   
 (__/ \_/\_/(__)  (_)   
"

info "Terraformed successfully by yap.sh."
if [[ -d $BAK ]]; then
  info "Backup files are stored in $BAK"
fi
if [[ $SHELL != $(which zsh) && -z $ZSH ]]; then
  info "To use terraformed ZSH, relogin or"
  echo
  info "  $ zsh"
  echo
fi

}; _ $@
