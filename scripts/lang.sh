#!/bin/bash
# Global language message function for DST scripts


# Get message from .properties file
get_msg() {
    local key="$1"
    local bin_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
    local lang_file="${bin_dir}/lang/${LANGUAGE:-en}.properties"
    if [ ! -f "$lang_file" ]; then
        lang_file="${bin_dir}/lang/en.properties"
    fi
    grep -E "^${key}=" "$lang_file" | head -n1 | cut -d'=' -f2-
}

export -f get_msg
