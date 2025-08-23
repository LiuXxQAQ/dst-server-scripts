#!/bin/bash
#
# Usage:
#   ./dst-stop.sh <server_type> [cluster_name] [signal]
#
# <server_type>: Master or Caves (required)
# [cluster_name]: Cluster name (optional, default: Cluster_1)
# [signal]: Signal to send to process (optional, default: 5)
#
# This script stops a DST server process by sending a signal (default SIGTRAP/5).


cd $(dirname $0)/../
source scripts/lang.sh

server_type=$1
cluster_name=${2:-Cluster_1}
signal=${3:-5}

# Find the process ID(s) for the DST server
pid=($(ps aux | grep -i dontstarve | grep -i ${server_type} | grep -i ${cluster_name} | grep -v grep | awk '{print $2}'))
if [ -z "${pid}" ]; then
    get_msg not_running "$server_type"
    exit 1
fi
# Normal stop
get_msg stop_running "$server_type"
kill -${signal} ${pid} >/dev/null 2>&1
get_msg shutdown_signal "$server_type"
echo $pid >>.lastpid
