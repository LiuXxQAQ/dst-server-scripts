#!/bin/bash
#
# Usage:
#   ./setup-sys-centos_32.sh
#
# This script installs required libraries and utilities for DST server on CentOS 32-bit systems.

set -e

yum -y install glibc libstdc++ glibc.i686
yum -y install wget tree
