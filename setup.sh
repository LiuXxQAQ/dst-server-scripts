#!/bin/bash
#
# Usage:
#   ./setup.sh
#
# This script loads configuration, checks system type, and initializes the system environment for DST server deployment.
#

# Load configuration file
setup_config() {
    local config_path="${bin}/config"
    echo "Current path: $0, Config path: ${config_path}"
    source "${config_path}/config.properties"
    echo "Current config file list:"
    cat "${config_path}/config.properties"
    read -p "Confirm all configuration information (Y/N)?" confirm
    if [[ "${confirm}" =~ ^[Yy] ]]; then
        echo "------------------------------------"
    else
        echo "Please re-run after confirming all configuration adjustments!"
        exit 1
    fi
}

# Detect system type
check_system() {
    if [[ -n $(find /etc -name "redhat-release") ]] || grep </proc/version -q -i "centos"; then
        release="centos"
    elif grep </etc/issue -q -i "debian" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "debian" && [[ -f "/proc/version" ]]; then
        release="debian"
    elif grep </etc/issue -q -i "ubuntu" && [[ -f "/etc/issue" ]] || grep </etc/issue -q -i "ubuntu" && [[ -f "/proc/version" ]]; then
        release="ubuntu"
    fi
    if [[ -z ${release} ]]; then
        echo "Other systems are not supported yet."
        exit 1
    fi
}

# Initialize system environment
setup_sys_env() {
    check_system
    local script="scripts/setup-sys-${release}_$(getconf LONG_BIT).sh"
    if [ -f "$script" ]; then
        echo "Detected system: ${release} $(getconf LONG_BIT)bit, executing script: $script"
        sh "$script"
    else
    echo "This system is not supported, exiting."
    exit 1
    fi
}

# Create dedicated user
setup_user() {
    if id ${STEAMCMD_USERNAME} >/dev/null 2>&1; then
        echo "User already exists, skipping creation and proceeding with remaining steps."
    else
        useradd ${STEAMCMD_USERNAME}
        echo "Please enter a password for user ${STEAMCMD_USERNAME}:"
        passwd ${STEAMCMD_USERNAME}
        echo "User ${STEAMCMD_USERNAME} created successfully."
    fi
}

# Initialize steamcmd
setup_steamcmd() {
        su - ${STEAMCMD_USERNAME} -c "
    mkdir -p ~/${STEAMCMD_PATH} \
    && cd ~/${STEAMCMD_PATH} \
    && wget -P ~/${STEAMCMD_PATH} https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
    && tar -xvzf ~/${STEAMCMD_PATH}/steamcmd_linux.tar.gz
    "
}

# Copy scripts to the specified directory
setup_scripts() {
    local target_path=/home/${STEAMCMD_USERNAME}/${DST_SCRIPT_PATH}
    su - ${STEAMCMD_USERNAME} -c "mkdir -p ${target_path}"
    cp -r ./* ${target_path}
    find ${target_path} -name \*.sh -print | xargs -n 1 chmod u+x
    chown -R ${STEAMCMD_USERNAME} ${target_path}
    mkdir -p "$DST_RUN_PATH"
    chown -R ${STEAMCMD_USERNAME} ${DST_RUN_PATH}
    echo "Scripts copied to ${target_path} successfully."
}

setup_dstserver() {
    su - ${STEAMCMD_USERNAME} -c "sh ~/$DST_SCRIPT_PATH/scripts/setup-dst.sh $STEAMCMD_PATH $DST_SCRIPT_PATH $DST_SERVER_PATH $DST_GAME_ID"
}

print_info() {
    echo ""
    echo "File structure:"
    tree -P '*.sh|*.properties|*.cmd|*.log' --prune /home/${STEAMCMD_USERNAME}
    echo "---------------------------------------------------------------------------------------"
    echo "Key directories:"
    echo "  Save location: /home/${STEAMCMD_USERNAME}/.Klei/DoNotStarveTogether/${DST_CLUSTER_NAME}"
    echo "  Mods location: /home/${STEAMCMD_USERNAME}/${DST_SERVER_PATH}/mods"
    echo ""
    echo "Next steps:"
    echo "  1. su ${STEAMCMD_USERNAME}"
    echo "  2. cd ~"
    echo "  3. mkdir -p ~/.Klei/DoNotStarveTogether"
    echo "  4. Prepare saves and mods, copy them to the specified directory"
    echo "  5. cd ~/${DST_SCRIPT_PATH}"
    echo "  6. start.sh"
    echo "If you want to configure a scheduled task, please start the server crond service, then run the following command:"
    echo "  crontab -u ${STEAMCMD_USERNAME} /home/${STEAMCMD_USERNAME}/${DST_SCRIPT_PATH}/config/cron.cmd"
    echo ""
    echo "---------------------------------------------------------------------------------------"
    echo ""
}

cd $(dirname $0)
bin=$(pwd)
setup_config
setup_sys_env
setup_user
setup_steamcmd
setup_scripts
setup_dstserver
print_info
