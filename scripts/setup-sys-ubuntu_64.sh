#!/bin/sh
#
# Usage:
#   ./setup-sys-ubuntu_64.sh
#
# This script installs required 32-bit libraries and utilities for DST server on Ubuntu 64-bit systems.

set -e

sudo add-apt-repository multiverse
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 lib32gcc-s1 wget tree