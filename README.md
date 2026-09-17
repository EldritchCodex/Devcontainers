# EldritchCodex Development Containers

Shared Linux graphics development image for Nodens, Nyar, and Template-NodensApp.

## Images

Shared image:

```text
ghcr.io/eldritchcodex/linux-graphics-dev:main
```

The image owns the full toolchain. GPU devices and NVIDIA runtime defaults stay
in each consuming project's `devcontainer.json`. The image does not contain
NVIDIA kernel drivers. Docker injects host NVIDIA libraries when `--gpus=all` is
used.

The image is Linux-only and currently targets `linux/amd64`. It contains:

- Clang, LLD, CMake, Ninja, GDB, Git, and common build utilities.
- OpenGL/Mesa and libglvnd userspace libraries.
- GLFW with X11 and Wayland support.
- X11 and Wayland development packages, including `libxkbcommon`.
- Vulkan headers, loader, validation layers, tools, and SPIR-V tools.
- Pinned `slangc` from an official Shader-Slang release.
- Non-root `eldritchcodex` user with passwordless sudo.

## GPU configuration

Each project uses plain `image` Dev Container configuration. No Docker Compose
or host GPU detection runs.

Generic Intel/AMD configuration uses:

```json
"image": "ghcr.io/eldritchcodex/linux-graphics-dev:main",
"runArgs": [
    "--device=/dev/dri",
    "--group-add=video",
    "--group-add=render"
]
```

NVIDIA configuration uses the same image with:

```json
"runArgs": ["--gpus=all"],
"containerEnv": {
    "NVIDIA_DRIVER_CAPABILITIES": "graphics,display,utility"
}
```

NVIDIA hosts need NVIDIA Container Toolkit configured in Docker:

```sh
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

The host must provide the display environment. The project configurations mount
`/tmp/.X11-unix` for X11 and `${XDG_RUNTIME_DIR}` for Wayland, and pass through
`DISPLAY`, `WAYLAND_DISPLAY`, and `XDG_RUNTIME_DIR`.

X11-only hosts need `/tmp/.X11-unix`. Wayland hosts need a valid
`XDG_RUNTIME_DIR`. X11 authentication may require host-specific setup.

## Repository layout

```text
linux-graphics/
├── Dockerfile
├── .bashrc
├── README.md
└── scripts/
    ├── create-user.sh
    ├── install-git-prompt.sh
    ├── install-packages.sh
    └── install-slang.sh
.devcontainer/
└── devcontainer.json
.github/workflows/
└── publish-linux-graphics.yml
```

## Local image build

Build the shared image:

```sh
docker build --pull \
    -t ghcr.io/eldritchcodex/linux-graphics-dev:main \
    linux-graphics
```

Rebuild or reopen the project Dev Container after changing the image.

The publish workflow pushes the image on `main`, version tags, or manual
dispatch. Make the GHCR package public when anonymous pulls are needed.

## Relationship to Nodens and Nyar

Nodens, Nyar, and Template-NodensApp keep their own source repositories and
build configurations. They use this shared toolchain image and do not publish
project-specific images unless a project later needs unique dependencies.
