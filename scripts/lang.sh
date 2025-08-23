#!/bin/sh
# Global language message function for DST scripts

# Ensure LANGUAGE is set from config if not already
if [ -z "$LANGUAGE" ]; then
    # 递归向上查找包含 lang 目录的路径
    search_dir="$PWD"
    while [ "$search_dir" != "/" ]; do
        if [ -d "$search_dir/lang" ]; then
            bin_dir="$search_dir"
            break
        fi
        search_dir="$(dirname "$search_dir")"
    done
    if [ -z "$bin_dir" ]; then
        bin_dir="$(cd "$(dirname "$0")/../" && pwd)"
    fi
    config_file="$bin_dir/config/config.properties"
    if [ -f "$config_file" ]; then
        . "$config_file"
    fi
fi

# Get message from .properties file
get_msg() {
    key="$1"
    shift
    # 使用上面查到的 bin_dir
    lang_file="${bin_dir}/lang/${LANGUAGE:-en}.properties"
    if [ ! -f "$lang_file" ]; then
        lang_file="${bin_dir}/lang/en.properties"
    fi
    raw_msg=$(grep -E "^${key}=" "$lang_file" | head -n1 | cut -d'=' -f2-)
    if [ $# -gt 0 ]; then
        printf "$raw_msg\n" "$@"
    else
        printf "%s\n" "$raw_msg"
    fi
}


