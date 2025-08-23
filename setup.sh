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
    echo "$(get_msg current_path) ${config_path}"
    source "${config_path}/config.properties"
    echo "-------------------- $(get_msg config_list) --------------------"
    awk -F'=' 'NF==2 {printf "%-25s = %s\n", $1, $2}' "${config_path}/config.properties"
    echo "------------------------------------------------------"
    read -p "$(get_msg confirm_config)" confirm
    if [[ "${confirm}" =~ ^[Yy] ]]; then
        echo "------------------------------------"
    else
        get_msg rerun_after_config
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
    get_msg system_not_supported
    exit 1
    fi
}

# Initialize system environment
setup_sys_env() {
    check_system
    local script="scripts/setup-sys-${release}_$(getconf LONG_BIT).sh"
    if [ -f "$script" ]; then
        get_msg detected_system "${release}" "$(getconf LONG_BIT)" "$script"
        sh "$script"
    else
    get_msg system_not_supported
    exit 1
    fi
}

# Create dedicated user
setup_user() {
    if id ${STEAMCMD_USERNAME} >/dev/null 2>&1; then
        get_msg user_exists
    else
        useradd ${STEAMCMD_USERNAME}
        get_msg enter_password
        passwd ${STEAMCMD_USERNAME}
        get_msg user_created
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
    get_msg scripts_copied "${target_path}"
}

setup_dstserver() {
    su - ${STEAMCMD_USERNAME} -c "sh ~/$DST_SCRIPT_PATH/scripts/setup-dst.sh $STEAMCMD_PATH $DST_SCRIPT_PATH $DST_SERVER_PATH $DST_GAME_ID"
}

print_info() {
    echo ""
    get_msg file_structure
    tree -P '*.sh|*.properties|*.cmd|*.log' --prune /home/${STEAMCMD_USERNAME}
    echo "---------------------------------------------------------------------------------------"
    get_msg key_directories
    echo "  $(get_msg save_location): /home/${STEAMCMD_USERNAME}/.Klei/DoNotStarveTogether/${DST_CLUSTER_NAME}"
    echo "  $(get_msg mods_location): /home/${STEAMCMD_USERNAME}/${DST_SERVER_PATH}/mods"
    echo ""
    get_msg next_steps
    echo "  1. su ${STEAMCMD_USERNAME}"
    echo "  2. cd ~"
    echo "  3. mkdir -p ~/.Klei/DoNotStarveTogether"
    echo "  4. Prepare saves and mods, copy them to the specified directory"
    echo "  5. cd ~/${DST_SCRIPT_PATH}"
    echo "  6. start.sh"
    echo ""
    get_msg cron_tip
    echo "  crontab -u ${STEAMCMD_USERNAME} /home/${STEAMCMD_USERNAME}/${DST_SCRIPT_PATH}/config/cron.cmd"
    echo ""
    echo "---------------------------------------------------------------------------------------"
    echo ""
}

cd $(dirname $0)
bin=$(pwd)
source "${bin}/scripts/lang.sh"
setup_config
setup_sys_env
setup_user
setup_steamcmd
setup_scripts
setup_dstserver
print_info
