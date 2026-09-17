#!/usr/bin/env bash
# Install the common Linux C++ development and desktop windowing stack.
# This image supports building GLFW applications with both X11 and Wayland
# backends. Runtime display and GPU access are configured by consumers.

set -euo pipefail

pacman -Syyu --noconfirm

# Keep the package groups explicit. Apart from making the image easier to
# review, this makes it clear which dependencies belong in a future
# project-specific image instead of silently growing the shared base.
packages=(
    # Container and debugging utilities:
    # sudo for controlled package/tool installation inside the disposable
    # non-root development container; GDB provides native debugging.
    sudo
    gdb

    # C++ toolchain and build orchestration:
    # Clang and LLD compile/link C++ projects; CMake and Ninja configure and
    # build the projects used by Nodens and Nyar.
    clang
    lld
    cmake
    ninja

    # Source control and download support:
    # Git is required for project work and FetchContent dependencies; curl is
    # used by install-git-prompt.sh to fetch the pinned Git prompt helper;
    # ca-certificates enables TLS verification for HTTPS downloads.
    git
    curl
    ca-certificates

    # General build and archive utilities:
    # pkgconf assists CMake dependency discovery; unzip and file support
    # common source/tool archives and inspection tasks.
    pkgconf
    unzip
    file

    # OpenGL and GLFW:
    # Mesa and libglvnd provide Linux OpenGL userspace support. GLFW is a
    # shared window/input dependency and is required by Nyar's current
    # find_package(glfw3 REQUIRED) configuration.
    mesa
    libglvnd
    glfw

    # X11 development support:
    # These headers and libraries allow GLFW to build its X11 backend and are
    # also required by Nodens' current ImGui CMake integration.
    xorgproto
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    libxext
    libxfixes

    # Wayland development support:
    # These packages allow GLFW to build its Wayland backend. GLFW can then
    # select X11 or Wayland at runtime according to the host session.
    wayland
    wayland-protocols
    libxkbcommon

    # CMake modules used by some desktop-library builds, including the Arch
    # GLFW package's build metadata.
    extra-cmake-modules

    # Vulkan development and diagnostics:
    # Headers and the loader are needed to compile/link Vulkan applications;
    # validation layers, Vulkan tools, and SPIR-V tools support development
    # diagnostics and shader inspection for both Nodens and Nyar.
    vulkan-headers
    vulkan-icd-loader
    vulkan-validation-layers
    vulkan-tools
    spirv-tools
)

pacman -S --noconfirm "${packages[@]}"

pacman -Scc --noconfirm
