FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    ccache \
    automake \
    flex \
    lzop \
    bison \
    gperf \
    build-essential \
    zip \
    curl \
    zlib1g-dev \
    g++-multilib \
    libxml2-utils \
    bzip2 \
    libbz2-dev \
    libbz2-1.0 \
    squashfs-tools \
    pngcrush \
    schedtool \
    dpkg-dev \
    liblz4-tool \
    make \
    optipng \
    libssl-dev \
    pwgen \
    bc \
    libc6-dev-i386 \
    libx11-dev \
    lib32z1-dev \
    libgl1-mesa-dev \
    xsltproc \
    unzip \
    device-tree-compiler \
    python3 \
    python-is-python3 \
    cpio \
    wget \
    rsync \
    libncurses5-dev \
    libncursesw5-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /kernel

# Set environment variables
ENV ARCH=arm64
ENV SUBARCH=arm64

CMD ["/bin/bash"]
