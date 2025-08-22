#!/bin/bash
#
# Usage:
#   ./restart.sh [update]
#
# This script stops all DST server processes, waits for them to exit, optionally updates, and restarts the servers.

# Loop to check if processes have exited
wait_process_exit() {
    local remain_sleep=$1
    local each_sleep=$2
    for pid in $pids; do
        while kill -0 ${pid} >/dev/null 2>&1; do
            if [ $remain_sleep -le 0 ]; then
                return 1
            fi
            echo "Process still running, waiting ${each_sleep}s to recheck, remaining timeout is ${remain_sleep}s..."
            sleep $each_sleep
            ((remain_sleep -= $each_sleep))
        done
    done
    return 0
}

cd $(dirname $0)
bin=$(pwd)
source config/config.properties
source scripts/lang.sh
cd ~/$DST_SCRIPT_PATH
sh stop.sh
pids=($(cat .lastpid | awk '{print $1}'))
get_msg waiting_exit
wait_process_exit 60 5
if [ $? -ne 0 ]; then
    get_msg stop_timeout
    sh stop.sh 9
    get_msg waiting_exit_forcibly
    wait_process_exit 60 5
    get_msg process_exited
fi
update=${1:-0}
if [ $update -eq 1 ]; then
    get_msg updating_server
    sh scripts/setup-dst.sh $STEAMCMD_PATH $DST_SCRIPT_PATH $DST_SERVER_PATH $DST_GAME_ID
fi
sh start.sh
