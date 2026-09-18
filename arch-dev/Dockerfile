# Shared Linux graphics development image for EldritchCodex projects.
#
# Nodens and Nyar use the same desktop, Vulkan, and shader development stack.
# Display sockets and GPU devices are intentionally supplied by each
# consuming project's devcontainer.json at runtime.
FROM archlinux:latest

COPY scripts/install-packages.sh /tmp/install-packages.sh
RUN chmod +x /tmp/install-packages.sh \
    && /tmp/install-packages.sh \
    && rm /tmp/install-packages.sh

COPY scripts/install-slang.sh /tmp/install-slang.sh
RUN chmod +x /tmp/install-slang.sh \
    && /tmp/install-slang.sh \
    && rm /tmp/install-slang.sh

COPY scripts/create-user.sh /tmp/create-user.sh
RUN chmod +x /tmp/create-user.sh \
    && /tmp/create-user.sh eldritchcodex \
    && rm /tmp/create-user.sh

COPY scripts/install-git-prompt.sh /tmp/install-git-prompt.sh
RUN chmod +x /tmp/install-git-prompt.sh \
    && /tmp/install-git-prompt.sh eldritchcodex \
    && rm /tmp/install-git-prompt.sh

COPY --chown=eldritchcodex:eldritchcodex .bashrc /home/eldritchcodex/.bashrc

USER eldritchcodex
