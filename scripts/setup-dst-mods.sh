#!/bin/bash
#
# setup-dst-mods.sh - Generate DST server mod setup file from modoverrides.lua
#
# Usage:
#   ./setup-dst-mods.sh DST_CLUSTER_NAME DST_SERVER_PATH
#
# Arguments:
#   DST_CLUSTER_NAME   Name of the DST cluster (e.g., Server_Cluster_1)
#   DST_SERVER_PATH    Path to the DST server directory (relative to ~)
#
# This script reads the modoverrides.lua file for the given cluster and writes
# ServerModSetup lines for each mod to the dedicated_server_mods_setup.lua file.
#

if [ $# -ne 2 ]; then
    echo "Usage: $0 DST_CLUSTER_NAME DST_SERVER_PATH"
    echo "Example: $0 Server_Cluster_1 dst_server"
    exit 1
fi

DST_CLUSTER_NAME="$1"
DST_SERVER_PATH="$2"

MODOVERRIDES=~/.klei/DoNotStarveTogether/${DST_CLUSTER_NAME}/Master/modoverrides.lua
OUTPUT=~/${DST_SERVER_PATH}/mods/dedicated_server_mods_setup.lua

# Extract mod IDs and write ServerModSetup lines
grep -o '"workshop-[0-9]\+"' "$MODOVERRIDES" | sed 's/"//g' | while read modid; do
    # Remove 'workshop-' prefix for ServerModSetup
    id=${modid#workshop-}
    echo "ServerModSetup(\"$id\")"
done > "$OUTPUT"
echo "Wrote mod setup to $OUTPUT."