#!/bin/sh
#
# Usage:
#   ./start.sh
#
# This script starts the DST Master and (optionally) Caves servers, logging output.


bin="$(cd "$(dirname "$0")" && pwd)"
. ${bin}/scripts/lang.sh

cluster_name="${DST_CLUSTER_NAME:-Server_Cluster_1}"
# Check if the cluster directory exists
cluster_folder="$HOME/.klei/DoNotStarveTogether/$cluster_name"
if [ ! -d "$cluster_folder" ]; then
    get_msg cluster_missing "$cluster_folder"
    exit 1
fi

dst_log_path="$bin/$DST_LOG_PATH"
mkdir -p "$dst_log_path"

# Generate the mod setup file before starting the server
sh scripts/setup-dst-mods.sh "${DST_CLUSTER_NAME}" "${DST_SERVER_PATH}" "${DST_MOD_ENABLE}"

# Fix cluster directory permissions to ensure writable
save_dir="$HOME/.klei/DoNotStarveTogether/${DST_CLUSTER_NAME}/"
if [ -d "$save_dir" ]; then
    chmod -R u+rw "$save_dir"
fi

# Start the Master server
sh scripts/dst-start.sh Master ${DST_CLUSTER_NAME} >>$dst_log_path/Master_${DST_CLUSTER_NAME}.log 2>&1
if [ $? -ne 0 ]; then
    get_msg start_failed "Master"
    exit 1
fi
get_msg starting "Master"

# Start the Caves server if enabled
if [ $DST_CAVES_ENABLE -eq 1 ]; then
    sh scripts/dst-start.sh Caves ${DST_CLUSTER_NAME} >>$dst_log_path/Caves_${DST_CLUSTER_NAME}.log 2>&1
    if [ $? -ne 0 ]; then
        get_msg start_failed "Caves"
        exit 1
    fi
    get_msg starting "Caves"
fi

# Output room info and c_connect command (multilingual)
cluster_ini="$HOME/.klei/DoNotStarveTogether/${DST_CLUSTER_NAME}/cluster.ini"
echo "$cluster_ini"
if [ -f "$cluster_ini" ]; then
    cluster_name=$(grep '^cluster_name' "$cluster_ini" | cut -d= -f2-)
    cluster_desc=$(grep '^cluster_description' "$cluster_ini" | cut -d= -f2-)
    cluster_intention=$(grep '^cluster_intention' "$cluster_ini" | cut -d= -f2-)
    cluster_pw=$(grep '^cluster_password' "$cluster_ini" | head -n1 | cut -d= -f2- | tr -d '\r' | xargs)
    cluster_max_players=$(grep '^max_players' "$cluster_ini" | cut -d= -f2-)
    cluster_game_mode=$(grep '^game_mode' "$cluster_ini" | cut -d= -f2-)
    echo "$(get_msg room_info_title)"
    printf "%s\n" "$(get_msg room_name "$cluster_name")"
    printf "%s\n" "$(get_msg room_desc "$cluster_desc")"
    if [ -n "$cluster_pw" ]; then
        printf "%s\n" "$(get_msg room_password "$cluster_pw")"
    else
        printf "%s\n" "$(get_msg room_password_none)"
    fi
    if [ -n "$cluster_max_players" ]; then
        printf "%s\n" "$(get_msg room_max_players "$cluster_max_players")"
    fi
    if [ -n "$cluster_game_mode" ]; then
        printf "%s\n" "$(get_msg room_game_mode "$cluster_game_mode")"
    fi
    echo "$(get_msg connect_title)"
    server_ip=$(curl -s ifconfig.me || hostname -I | awk '{print $1}')
    server_port=10999
    echo "$(get_msg connect_tip)"
    if [ -n "$cluster_pw" ]; then
        echo "c_connect(\"${server_ip}\", ${server_port}, \"${cluster_pw}\")"
    else
        echo "c_connect(\"${server_ip}\", ${server_port})"
    fi
else    
    echo "$(get_msg cluster_ini_missing)"
fi
