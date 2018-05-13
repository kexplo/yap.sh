#!/usr/bin/env bash

if is_ubuntu_16_04; then
  info "Setting up the Python environment..."
  sudo apt install -y \
    python \
    python-dev \
    python-setuptools \
    python-pip \
    virtualenv

  sudo apt install -y python3-dev
fi
