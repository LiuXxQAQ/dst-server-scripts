#!/bin/bash
#
# Usage:
#   ./start.sh
#
# This script starts the DST Master and (optionally) Caves servers, logging output.

bin="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${bin}/config/config.properties

dst_log_path=$bin/$DST_LOG_PATH
mkdir -p "$dst_log_path"

# If mod support is enabled, generate the mod setup file before starting the server
if [ "${DST_MOD_ENABLE}" = "1" ]; then
    echo "Mod support enabled. Generating mod setup file..."
    sh scripts/setup-dst-mods.sh "${DST_CLUSTER_NAME}" "${DST_SERVER_PATH}"
fi

sh scripts/dst-start.sh Master ${DST_CLUSTER_NAME} >>$dst_log_path/Master_${DST_CLUSTER_NAME}.log 2>&1
if [ $? -ne 0 ]; then
    echo "DST server(Master,$DST_CLUSTER_NAME) is running, no more instance to start"
    exit 1
fi
echo "DST server(Master,$DST_CLUSTER_NAME) is starting, service will be ready in several time..."
if [ $DST_CAVES_ENABLE -eq 1 ]; then
    sh scripts/dst-start.sh Caves ${DST_CLUSTER_NAME} >>$dst_log_path/Caves_${DST_CLUSTER_NAME}.log 2>&1
    if [ $? -ne 0 ]; then
        echo "DST server(Caves,$DST_CLUSTER_NAME) is running, no more instance to start"
        exit 1
    fi
    echo "DST server(Caves,$DST_CLUSTER_NAME) is starting, service will be ready in several time..."
fi
