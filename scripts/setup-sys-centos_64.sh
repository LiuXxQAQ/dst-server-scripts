#!/bin/bash
#
# Usage:
#   ./setup-sys-centos_64.sh
#
# This script installs required 32-bit libraries and utilities for DST server on CentOS 64-bit systems.

set -e

yum -y install glibc.i686 libstdc++.i686
yum -y install wget tree
