#!/usr/bin/env bash
# Create the non-root user used by project devcontainers.

set -euo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <username>" >&2
    exit 1
fi

username="$1"

groupadd --system --force video
groupadd --system --force render
useradd --create-home --shell /bin/bash --groups video,render "${username}"

sudoers_file="/etc/sudoers.d/${username}"
printf '%s\n' "${username} ALL=(ALL) NOPASSWD:ALL" > "${sudoers_file}"
chmod 0440 "${sudoers_file}"
visudo --check --file "${sudoers_file}"
