#!/usr/bin/env bash

if is_ubuntu_16_04; then
  info "Setting up the Python environment..."
  sudo apt-get install -y \
    python \
    python-dev \
    python-setuptools \
    python-pip \
    python3-dev \
    virtualenv
fi
