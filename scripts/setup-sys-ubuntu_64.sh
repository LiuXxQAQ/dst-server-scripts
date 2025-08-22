#!/bin/bash
#
# Usage:
#   ./setup-sys-ubuntu_64.sh
#
# This script installs required 32-bit libraries and utilities for DST server on Ubuntu 64-bit systems.

set -e

sudo apt-get install -y libstdc++6:i386 libgcc1:i386 libcurl4-gnutls-dev:i386 lib32gcc1 wget tree