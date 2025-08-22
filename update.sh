#!/bin/bash
#
# Usage:
#   ./update.sh
#
# This script restarts the DST server and triggers an update.

cd $(dirname $0)
bin=$(pwd)
source scripts/lang.sh
get_msg updating_server
sh restart.sh 1
