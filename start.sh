#!/bin/bash
#
# Usage:
#   ./start.sh
#
# This script starts the DST Master and (optionally) Caves servers, logging output.


bin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${bin}/scripts/lang.sh

dst_log_path=$bin/$DST_LOG_PATH
mkdir -p "$dst_log_path"

# Generate the mod setup file before starting the server
sh scripts/setup-dst-mods.sh "${DST_CLUSTER_NAME}" "${DST_SERVER_PATH}" "${DST_MOD_ENABLE}"

sh scripts/dst-start.sh Master ${DST_CLUSTER_NAME} >>$dst_log_path/Master_${DST_CLUSTER_NAME}.log 2>&1
if [ $? -ne 0 ]; then
    get_msg running "Master"
    exit 1
fi
get_msg starting "Master"
if [ $DST_CAVES_ENABLE -eq 1 ]; then
    sh scripts/dst-start.sh Caves ${DST_CLUSTER_NAME} >>$dst_log_path/Caves_${DST_CLUSTER_NAME}.log 2>&1
    if [ $? -ne 0 ]; then
        get_msg running "Caves"
        exit 1
    fi
    get_msg starting "Caves"
fi
