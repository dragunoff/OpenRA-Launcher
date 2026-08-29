FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu

ENV FLUTTER_SDK_ROOT=/usr/lib/flutter
ENV FLUTTER_SDK_VERSION=3.44.6-stable
ENV PATH="${PATH}:${FLUTTER_SDK_ROOT}/bin"
ENV DEBIAN_FRONTEND=noninteractive

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Install tools for the vscode user
RUN apt-get update && \
    apt-get install -y \
        clang \
        cmake \
        ninja-build \
        build-essential \
        pkg-config \
        libgtk-3-dev \
        sudo \
        wget \
        unzip \
        zip \
        curl \
        git \
        xz-utils \
        libglu1-mesa \
        libc6:amd64 \
        libstdc++6:amd64 \
        lib32z1 \
        libbz2-1.0:amd64 && \
    rm -rf /var/lib/apt/lists/*

# Enable sudo for the devcontainer user
RUN echo "$USERNAME ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME

# Install Flutter SDK
RUN mkdir -p ${FLUTTER_SDK_ROOT} && \
    cd /tmp && \
    curl -OL https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz && \
    tar -xf flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz -C /usr/lib/ && \
    rm -f flutter_linux_${FLUTTER_SDK_VERSION}.tar.xz && \
    chown -R ${USERNAME}:${USERNAME} ${FLUTTER_SDK_ROOT}

# Run Flutter tooling as the non-root devcontainer user
USER ${USERNAME}
RUN yes | flutter doctor && \
    flutter config --no-analytics && \
    flutter update-packages

RUN dart --disable-analytics

USER root

RUN curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path && \
    mv /root/.opencode/bin/opencode /usr/local/bin/opencode

SHELL ["/bin/bash", "-c"]
