# Use Ubuntu 16.04 as the base image
FROM ubuntu:16.04

# Set environment variables to prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    software-properties-common \
    build-essential \
    vim \
    git \
    wget \
    gdb \
    sudo \
    libglib2.0-dev \
    libfdt-dev \
    libpixman-1-dev \
    zlib1g-dev \
    python \
    pkg-config \
    autoconf \
    automake \
    libtool

# Add the PPA repository for gcc-7 and install it
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y && \
    apt-get update && \
    apt-get install -y gcc-7 g++-7

# Set gcc-7 as the default gcc
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 60 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-7 60 && \
    update-alternatives --set gcc /usr/bin/gcc-7 && \
    update-alternatives --set g++ /usr/bin/g++-7

# Download and install QEMU 2.5.0
RUN wget https://download.qemu.org/qemu-2.5.0.tar.bz2 && \
    tar -xjf qemu-2.5.0.tar.bz2 && \
    cd qemu-2.5.0 && \
    ./configure --python=/usr/bin/python && \
    make && \
    make install && \
    cd .. && \
    rm -rf qemu-2.5.0 qemu-2.5.0.tar.bz2

# Set up the working directory
WORKDIR /workspace

# Optional: Clone the pintos-kaist repository
# RUN git clone https://github.com/casys-kaist/pintos-kaist .

ARG UID=<호스트 UID>
ARG GID=<호스트 GID>

# 그룹과 사용자 생성
RUN groupadd -g $GID mygroup && \
    useradd -u $UID -g $GID -m nokdoot

# 필요한 경우, USER 명령으로 해당 사용자 지정
USER nokdoot

# Add activate script to bashrc for convenience
RUN echo "source /workspace/activate" >> ~/.bashrc

# Default command
CMD ["/bin/bash"]

