#!/bin/bash
# Global language message function for DST scripts

# Ensure LANGUAGE is set from config if not already
if [ -z "$LANGUAGE" ]; then
    bin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
    config_file="$bin_dir/config/config.properties"
    if [ -f "$config_file" ]; then
        . "$config_file"
    fi
fi

# Get message from .properties file
get_msg() {
    local key="$1"
    shift
    local bin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
    local lang_file="${bin_dir}/lang/${LANGUAGE:-en}.properties"
    if [ ! -f "$lang_file" ]; then
        lang_file="${bin_dir}/lang/en.properties"
    fi
    local raw_msg
    raw_msg=$(grep -E "^${key}=" "$lang_file" | head -n1 | cut -d'=' -f2-)
    if [ $# -gt 0 ]; then
        printf "$raw_msg\n" "$@"
    else
        printf "%s\n" "$raw_msg"
    fi
}

export -f get_msg
