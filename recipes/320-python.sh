#!/usr/bin/env bash

if is_ubuntu_16_04; then
  info "Setting up the Python environment..."
  sudo apt-get install -y \
    python2.7 \
    python2.7-dev

  sudo apt-get install -y \
    python-setuptools \
    python-pip \
    virtualenv

  sudo apt-get install -y python3 python3-dev
fi
