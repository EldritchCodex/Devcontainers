#!/usr/bin/env bash
# Install the Slang compiler from an official, pinned upstream release.
# Arch's official repositories do not provide shader-slang/slangc; the
# similarly named `slang` package is an unrelated S-Lang interpreter.

set -euo pipefail

slang_version="2026.18"
slang_archive="slang-${slang_version}-linux-x86_64-glibc-2.28.tar.gz"
slang_url="https://github.com/shader-slang/slang/releases/download/v${slang_version}/${slang_archive}"
slang_sha256="8f27819f6bce2e37f3549e204b57a954d8daee67a5a5735cdc437b8bc7b87a50"

work_dir="$(mktemp -d)"
trap 'rm -rf "${work_dir}"' EXIT

curl --fail --location --retry 3 --silent --show-error \
    "${slang_url}" \
    --output "${work_dir}/${slang_archive}"

echo "${slang_sha256}  ${work_dir}/${slang_archive}" | sha256sum --check --status

install --directory /opt/slang
# The release archive already has bin/, lib/, include/, and share/ at its
# root. Preserve those directories so the runtime libraries and compiler are
# installed under the paths expected below.
tar --extract \
    --gzip \
    --file "${work_dir}/${slang_archive}" \
    --directory /opt/slang

install --directory /usr/local/bin
ln --symbolic --force /opt/slang/bin/slangc /usr/local/bin/slangc

if [[ -d /opt/slang/lib ]]; then
    printf '%s\n' /opt/slang/lib > /etc/ld.so.conf.d/slang.conf
    ldconfig
fi

test -x /usr/local/bin/slangc
