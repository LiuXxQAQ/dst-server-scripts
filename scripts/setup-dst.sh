#!/bin/sh
#
# Usage:
#   ./setup-dst.sh STEAMCMD_PATH DST_SCRIPT_PATH DST_SERVER_PATH DST_GAME_ID
#
# Arguments:
#   STEAMCMD_PATH    Path to steamcmd directory (relative to ~)
#   DST_SCRIPT_PATH  Path to DST script directory (relative to ~)
#   DST_SERVER_PATH  Path to DST server directory (relative to ~)
#   DST_GAME_ID      DST game ID (e.g., 343050)
#
# This script sets up the DST server, runs steamcmd to update/install, fixes missing libs, and writes a cron job for auto-updates.

set -e

dst_path=~/$3
mkdir -p "$dst_path"
dst_path=$(cd "$dst_path" && pwd)
cmd_path="$2/config"

# Set steamcmd commands
echo "force_install_dir $dst_path" > ~/${cmd_path}/update_starve.cmd
echo "login anonymous" >> ~/${cmd_path}/update_starve.cmd
echo "app_update $4 validate" >> ~/${cmd_path}/update_starve.cmd
echo "quit" >> ~/${cmd_path}/update_starve.cmd

# Run steamcmd
steamcmd_path=~/$1/steamcmd.sh
echo "$steamcmd_path"
cmdfile=~/$cmd_path/update_starve.cmd
if ! "$steamcmd_path" < "$cmdfile"; then
    echo "SteamCMD 执行失败，请检查网络和参数！"
    exit 1
fi

# Fix missing libcurl-gnutls.so.4 if needed
cd "$dst_path/bin/lib32"
lib_file=libcurl-gnutls.so.4
if [ ! -L "$lib_file" ] && [ ! -f "$lib_file" ]; then
    ln -s /usr/lib/libcurl.so.4 "$lib_file"
fi

# Write cron expression for daily update
echo "0 3 * * * $(cd ~/${STEAMCMD_USERNAME}/$2 && pwd)/update.sh" > ~/${cmd_path}/cron.cmd