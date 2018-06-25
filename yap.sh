#!/usr/bin/env bash
# vim: set filetype=sh:
#
# yap.sh
# ~~~~~~
#
# Shortest way to terraform a Ubuntu 16.04 environment as for my taste
#
#  $ curl -sL yap.sh | bash
#   or
#  $ wget -qO- yap.sh | bash
#

set -euo pipefail; 

# Don't update APT if the last updated time is in a day.
readonly update_apt_after=86400
readonly apt_updated_at="$HOME/.yap.sh-apt-updated-at"

# Where some backup files to be stored.
readonly timestamp=$(date +%s)
readonly backup_dir=~/.yap.sh-bak-$timestamp

print_help () {
  # Print the help message for --help.
  echo "Usage: curl -sL yap.sh | bash [-s - OPTIONS]"
  echo
  echo "Options:"
  echo "  --help              Show this message and exit."
  echo "  --no-apt-update     Do not update APT package lists."
  echo "  --force-apt-update  Update APT package lists on regardless of"
  echo "                      updating period."
}

git_repo () {
  # Clone git repo. if the repo already exists, just pull
  local url="$1"
  local save_path="$2"

  if [[ -d "$save_path" ]]; then
    git -C "$save_path" pull --rebase
  else
    mkdir -p "$save_path"
    git clone "$url" "$save_path"
  fi
}

github_repo () {
  local url="$1"
  local save_path="$2"
  git_repo "https://github.com/$1" "$2"
}

secho () {
  local color="$1"
  local msg="$2"
  if [[ -z "$TERM" ]]; then
    echo "$msg"
  else
    echo -e "$(tput setaf "${color}")${msg}$(tput sgr0)"
  fi
}

info () {
  local msg="$1"
  # Print an information log.
  secho 6 "$msg"
}

err () {
  local msg="$1"
  # Print a red colored error message.
  secho 1 "$msg"
}

fatal () {
  # Print a red colored error message and exit the script.
  err "$@"
  exit 1
}

failed () {
  fatal "Failed to running yap.sh. Error on line $1"
}
trap 'failed $LINENO' ERR

sym_link () {
  # Make a symbolic link.  If something should be backed up at
  # the destination path, it moves that to $BAKUP_DIR.
  local src="$1"
  local dest="$2"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$(readlink -f "$src")" == "$(readlink -f "$dest")" ]]; then
      return
    fi
    mkdir -p "$backup_dir"
    mv "$dest" "$backup_dir"
  fi
  ln -s "$src" "$dest" 
}

check_ubuntu_ver () {
  local version="$1"
  if [ -f '/etc/os-release' ]; then
    # shellcheck disable=SC1091
    source '/etc/os-release'
    if [[ "$NAME" != "Ubuntu" ]]; then
      false
    fi
    if [[ "$VERSION_ID" != "$version" ]]; then
      false
    else
      true
    fi
  else
    false
  fi
}

is_ubuntu_16_04 () {
  check_ubuntu_ver "16.04"
}


is_ubuntu_18_04 () {
  check_ubuntu_ver "18.04"
}

is_osx () {
  [[ "$(uname)" == "Darwin" ]]
}

get_os_type () {
  if is_ubuntu_16_04; then
    echo "ubuntu1604"
  elif is_osx; then
    echo "osx"
  else
    echo "unknown"
  fi
}

has () {
  type "$1" > /dev/null 2>&1
}

brew_inst () {
  local brew_pkg="$1"
  if brew ls --versions "$brew_pkg" >/dev/null; then
    # Upgrade brew package if outdated
    if brew outdated | grep -q "$brew_pkg"; then
      brew upgrade "$brew_pkg"
    fi
  else
    # Install brew package if not installed
    brew install "$brew_pkg"
  fi
}
