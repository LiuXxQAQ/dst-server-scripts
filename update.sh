#!/bin/bash
#
# Usage:
#   ./update.sh
#
# This script restarts the DST server and triggers an update.

cd $(dirname $0)
bin=$(pwd)
sh restart.sh 1
