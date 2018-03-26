#!/usr/bin/env bash
# vim: set filetype=sh:
#
# yap.sh
# ~~~~~~
#
# Shortest way to terraform a Ubuntu 16.04 environment as for my taste
#
#  $ curl -sL yap.sh | bash [-s - OPTIONS]
#   or
#  $ wget -qO- yap.sh | bash [-s - OPTIONS]
#

set -euo pipefail; 

readonly YAPSH_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Don't update APT if the last updated time is in a day.
readonly UPDATE_APT_AFTER=86400
readonly APT_UPDATED_AT="$HOME/.yap.sh-apt-updated-at"

# Where some backup files to be stored.
readonly TIMESTAMP=$(date +%s)
readonly BACKUP_DIR=~/.yap.sh-bak-$TIMESTAMP

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
  fatal "Failed to terraform by yap.sh."
}
trap failed ERR

sym_link () {
  # Make a symbolic link.  If something should be backed up at
  # the destination path, it moves that to $BAKUP_DIR.
  local src="$1"
  local dest="$2"
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$(readlink -f "$src")" == "$(readlink -f "$dest")" ]]; then
      return
    fi
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR"
  fi
  ln -s "$src" "$dest" 
}

