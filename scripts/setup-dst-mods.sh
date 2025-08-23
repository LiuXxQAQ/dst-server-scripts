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

# Source global language function
source "$(cd "$(dirname "$0")/../scripts" && pwd)/lang.sh"

if [ $# -ne 3 ]; then
    echo "Usage: $0 DST_CLUSTER_NAME DST_SERVER_PATH DST_MOD_ENABLE"
    echo "Example: $0 Server_Cluster_1 dst_server 1"
    exit 1
fi

DST_CLUSTER_NAME="$1"
DST_SERVER_PATH="$2"
DST_MOD_ENABLE="$3"

OUTPUT=~/${DST_SERVER_PATH}/mods/dedicated_server_mods_setup.lua

# Clear OUTPUT if it exists
[ -f "$OUTPUT" ] && > "$OUTPUT"

if [ "$DST_MOD_ENABLE" = "0" ]; then
    get_msg mod_disable
    exit 1
fi

get_msg mod_enable

MODOVERRIDES=~/.klei/DoNotStarveTogether/${DST_CLUSTER_NAME}/Master/modoverrides.lua
# Check if modoverrides.lua exists
if [ ! -f "$MODOVERRIDES" ]; then
    get_msg modoverrides_missing "$MODOVERRIDES"
fi

# Extract mod IDs and write ServerModSetup lines
grep -o '"workshop-[0-9]\+"' "$MODOVERRIDES" | sed 's/"//g' | while read modid; do
    # Remove 'workshop-' prefix for ServerModSetup
    id=${modid#workshop-}
    echo "ServerModSetup(\"$id\")"
done > "$OUTPUT"
get_msg wrote_mod_setup "$OUTPUT"