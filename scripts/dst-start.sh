#!/bin/bash
#
# Usage:
#   ./dst-start.sh <server_type> [cluster_name]
#
# <server_type>: Master or Caves (required)
# [cluster_name]: Cluster name (optional, default: Server_Cluster_1 or value from config)
#
# This script starts a Don't Starve Together dedicated server shard (Master or Caves).
# It sources configuration from config/config.properties and sets up environment variables.
#
# Example:
#   ./dst-start.sh Master
#   ./dst-start.sh Caves MyCluster




# Source global language function
source "$(cd "$(dirname "$0")/../scripts" && pwd)/lang.sh"

# Function to run the DST server
run_server() {
    echo $$ > "$lock_file"
    ./dontstarve_dedicated_server_nullrenderer -console -cluster "$cluster_name" -shard "$server_type"
    rm -rf "$lock_file"
}

# Move to script directory root
cd "$(dirname "$0")/../" || exit 1
bin=$(pwd)

# Source configuration
source config/config.properties

# Parse arguments
server_type="$1"
cluster_name="${2:-${DST_CLUSTER_NAME:-Server_Cluster_1}}"


if [ -z "$server_type" ]; then
    echo "Error: <server_type> is required (Master or Caves)"
    echo "Usage: $0 <server_type> [cluster_name]"
    exit 1
fi

dst_server_bin=~/$DST_SERVER_PATH/bin
cd "$dst_server_bin" || exit 1
export SteamAppId=$DST_GAME_ID
export SteamGameId=$DST_GAME_ID
mkdir -p "$DST_RUN_PATH"
lock_file="$DST_RUN_PATH/${server_type}_${cluster_name}.lock"

if [ -f "$lock_file" ]; then
    get_msg already_running
    exit 1
fi

# Start server in background
nohup $(run_server) >/dev/null 2>&1 &