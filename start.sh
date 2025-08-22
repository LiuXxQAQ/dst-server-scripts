#!/bin/bash
#
# Usage:
#   ./start.sh
#
# This script starts the DST Master and (optionally) Caves servers, logging output.


bin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${bin}/scripts/lang.sh
source ${bin}/config/config.properties

dst_log_path=$bin/$DST_LOG_PATH
mkdir -p "$dst_log_path"

# If mod support is enabled, generate the mod setup file before starting the server
if [ "${DST_MOD_ENABLE}" = "1" ]; then
    get_msg mod_enable
    sh scripts/setup-dst-mods.sh "${DST_CLUSTER_NAME}" "${DST_SERVER_PATH}"
fi

sh scripts/dst-start.sh Master ${DST_CLUSTER_NAME} >>$dst_log_path/Master_${DST_CLUSTER_NAME}.log 2>&1
if [ $? -ne 0 ]; then
    get_msg master_running
    exit 1
fi
get_msg master_starting
if [ $DST_CAVES_ENABLE -eq 1 ]; then
    sh scripts/dst-start.sh Caves ${DST_CLUSTER_NAME} >>$dst_log_path/Caves_${DST_CLUSTER_NAME}.log 2>&1
    if [ $? -ne 0 ]; then
        get_msg caves_running
        exit 1
    fi
    get_msg caves_starting
fi
