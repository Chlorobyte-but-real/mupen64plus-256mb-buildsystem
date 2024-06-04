FROM ubuntu:xenial

ENV DEBIAN_FRONTEND="noninteractive"

ARG uid
ARG branch=master
ENV branch=$branch

ENV PACKAGES \
    alsa-utils \
    autoconf \
    automake \
    autopoint \
    bash \
    bc \
    bison \
    bsdmainutils \
    build-essential \
    bzip2 \
    ccache \
    chrpath \
    curl \
    debhelper \
    diffutils \
    doxygen \
    flex \
    fuse \
    g++ \
    g++-multilib \
    gawk \
    gcc \
    gettext \
    git \
    gnupg \
    gnupg2 \
    gperf \
    gzip \
    intltool \
    less \
    libaio-dev \
    libasound2-dev \
    libass-dev \
    libavdevice-dev \
    libbz2-dev \
    libc6-dev-i386 \
    libcaca-dev \
    libdrm-dev \
    libffi-dev \
    libflac-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libgbm-dev \
    libgdbm-dev \
    libgdk-pixbuf2.0-dev \
    libglib2.0-dev \
    libglm-dev \
    libglu1-mesa-dev \
    libgtk-3-dev \
    libgtk2.0-dev \
    libjack-jackd2-dev \
    libjson-perl \
    libltdl-dev \
    liblua5.3-dev \
    liblzma-dev \
    libmbedtls-dev \
    libminiupnpc-dev \
    libmpv-dev \
    libncurses5-dev \
    libopenal-dev \
    libosmesa6-dev \
    libpcap-dev \
    libreadline-dev \
    libroar-dev \
    libsdl2-dev \
    libsixel-dev \
    libslang2-dev \
    libssl-dev \
    libsystemd-dev \
    libtool \
    libtool-bin \
    libusb-1.0-0-dev \
    libv4l-dev \
    libvulkan-dev \
    libwayland-dev \
    libwxgtk3.0-dev \
    libx11-dev \
    libx11-xcb-dev \
    libxcb-shm0-dev \
    libxkbcommon-dev \
    libxml-parser-perl \
    libxml2-dev \
    lsb-release \
    lzip \
    lzop \
    make \
    mesa-common-dev \
    meson \
    nasm \
    nsis \
    p7zip-full \
    patch \
    patchutils \
    perl \
    pkg-config \
    python3-all-dev \
    qtbase5-dev \
    ruby \
    sed \
    software-properties-common \
    sudo \
    sunxi-tools \
    swig \
    tar \
    texinfo \
    u-boot-tools \
    unzip \
    uuid-dev \
    wayland-protocols \
    wget \
    x11proto-xext-dev \
    xfonts-utils \
    xsltproc \
    xz-utils \
    yasm \
    zlib1g-dev

RUN set -eux; \
    apt-get -y update; \
    apt-get -y install -y unzip; \
    useradd -d /developer -m developer; \
    chown -R developer:developer /developer

RUN set -eux; \
    echo "###### Ubuntu Main Repos" > /etc/apt/sources.list; \
    echo "deb http://de.archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo "deb-src http://de.archive.ubuntu.com/ubuntu/ xenial main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo  >> /etc/apt/sources.list; \
    echo "###### Ubuntu Update Repos" >> /etc/apt/sources.list; \
    echo "deb http://de.archive.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo "deb http://de.archive.ubuntu.com/ubuntu/ xenial-updates main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo "deb http://de.archive.ubuntu.com/ubuntu/ xenial-proposed main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo "deb http://de.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo "deb-src http://de.archive.ubuntu.com/ubuntu/ xenial-security main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo "deb-src http://de.archive.ubuntu.com/ubuntu/ xenial-updates main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo "deb-src http://de.archive.ubuntu.com/ubuntu/ xenial-proposed main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo "deb-src http://de.archive.ubuntu.com/ubuntu/ xenial-backports main restricted universe multiverse " >> /etc/apt/sources.list; \
    echo  >> /etc/apt/sources.list;

RUN set -eux; \
    apt-get update -y; \
    apt-get -y install $PACKAGES; \
    apt-get -y autoremove; \
    apt-get -y clean; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    apt-get upgrade -y; \
    apt-get dist-upgrade -y; \
    add-apt-repository -y --update ppa:ubuntu-toolchain-r/test; \
    apt-get update -y; \
    apt-get -y install gcc-9 g++-9; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    echo "1" | update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-9; \
    echo "1" | update-alternatives --config gcc

RUN set -eux; \
    apt-get update -y; \
    apt-get -y install apt-transport-https ca-certificates; \
    wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | sudo tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null; \
    apt-add-repository -y 'deb https://apt.kitware.com/ubuntu/ xenial main'; \
    apt-get update -y; \
    apt-get -y install kitware-archive-keyring; \
    rm /etc/apt/trusted.gpg.d/kitware.gpg; \
    apt-get -y install cmake; \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    cd /tmp; \
    wget --no-check-certificate -nv "https://www.openssl.org/source/openssl-1.1.1o.tar.gz" -O- | tar xz; \
    cd openssl-*; \
    CC=gcc-9 CXX=g++-9 ./config --prefix=/usr/local; \
    make -j$(nproc); \
    make install -j$(nproc); \
    cd ..; \
    rm -rf *; \
    rm -rf /usr/local/share/doc/*; \
    rm -rf /usr/local/share/man/*; \
    ldconfig

RUN set -eux; \
    cd /tmp; \
    wget -nv "https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tar.xz" -O- | tar xJ; \
    mkdir build; \
    cd build; \
    CC=gcc-9 CXX=g++-9 ../Python-*/configure \
        --prefix=/usr/local \
        --enable-optimizations \
    ; \
    make -j$(nproc); \
    make altinstall; \
    ln -sf /usr/local/bin/python3.10 /usr/local/bin/python3; \
    cd ..; \
    rm -rf *; \
    rm -rf /usr/local/share/doc/*; \
    rm -rf /usr/local/share/man/*; \
    ldconfig

RUN set -eux; \
    python3 -m pip install --upgrade --no-cache-dir pip; \
    python3 -m pip install --no-cache-dir \
        mako \
        ninja \
        pyyaml \
        setuptools \
        sphinx \
    ;

RUN echo "developer:developer" | chpasswd && adduser developer sudo

ENV HOME=/developer
ENV QT_SELECT=qt5

USER root
WORKDIR /developer

CMD /bin/bash
