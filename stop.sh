#!/bin/sh
#
# Usage:
#   ./stop.sh
#
# This script stops both the Master and Caves DST servers and clears the lastpid file.

cd $(dirname $0)
bin=$(pwd)
. scripts/lang.sh

cat /dev/null >.lastpid
sh scripts/dst-stop.sh Master $DST_CLUSTER_NAME
sh scripts/dst-stop.sh Caves $DST_CLUSTER_NAME
get_msg stop_success
