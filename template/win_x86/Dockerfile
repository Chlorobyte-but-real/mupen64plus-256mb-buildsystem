FROM ubuntu:bionic

ENV DEBIAN_FRONTEND="noninteractive"

ARG uid
ARG branch=master
ENV branch=$branch

# Note: GCC 11 is set as the default compiler in this commit
ARG MXE_COMMIT=d48a58b748601aa64a918cae38c1054dda41533e

ENV PACKAGES \
    build-essential \
    bash \
    curl \
    ccache \
    gcc \
    g++ \
    g++-multilib \
    gettext \
    git \
    gnupg \
    gnupg2 \
    make \
    cmake \
    nsis \
    python \
    python2.7 \
    python-mako \
    python3 \
    python3-mako \
    python3-pkg-resources \
    python3-pip \
    python3-yaml \
    python3-sphinx \
    python3-setuptools \
    texinfo \
    autoconf \
    automake \
    autopoint \
    bison \
    bzip2 \
    flex \
    gettext \
    gperf \
    intltool \
    less \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libssl-dev \
    libtool \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    meson \
    ninja-build \
    openssl \
    p7zip-full \
    patch \
    perl \
    pkg-config \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils \
    nasm \
    bsdmainutils

RUN set -eux; \
    apt-get update; \
    apt-get -y install $PACKAGES; \
    apt-get -y autoremove; \
    apt-get -y clean; \
    rm -rf /var/lib/apt/lists/*; \
    useradd -d /developer -m developer; \
    chown -R developer:developer /developer

ENV MXE_PACKAGES \
    cc \
    cmake \
    bzip2 \
    curl \
    gcc \
    glib \
    gmp \
    gnutls \
    libpng \
    nettle \
    pixman \
    pkgconf \
    dlfcn-win32 \
    libsndfile \
    sdl_net \
    sdl2 \
    zlib \
    libxml2 \
    freetype \
    fribidi \
    ninja \
    nasm \
    vulkan-loader

# MXE 'require check' for mako-render package
# always fails - must manually remove this
# requirement from the Makefile...
RUN set -eux; \
    cd /usr/lib; \
    mkdir mxe; \
    cd mxe; \
    git init; \
    git remote add origin 'https://github.com/mxe/mxe.git'; \
    git fetch --depth=1 origin ${MXE_COMMIT}; \
    git checkout ${MXE_COMMIT}; \
    sed -i '/mako-render/d' Makefile; \
    make check-requirements; \
    echo '' >> settings.mk; \
    echo 'JOBS :=' $(nproc) >> settings.mk; \
    echo 'MXE_TMP := /tmp/mxe' >> settings.mk; \
    echo 'MXE_TARGETS := x86_64-w64-mingw32.static i686-w64-mingw32.static' >> settings.mk; \
    echo 'MXE_USE_CCACHE=' >> settings.mk; \
    echo '' >> settings.mk; \
    echo 'gcc_CONFIGURE_OPTS := --enable-languages=c,c++' >> settings.mk;

RUN set -eux; \
    cd /usr/lib/mxe; \
    make $MXE_PACKAGES; \
    make clean-junk; \
    rm -rf pkg/*

# Treat all directories as safe, otherwise git will fail because of:
# https://github.blog/2022-04-12-git-security-vulnerability-announced
RUN git config --global --add safe.directory '*'

RUN echo "developer:developer" | chpasswd && adduser developer sudo

ENV HOME=/developer
ENV PATH=/usr/lib/mxe/usr/bin:$PATH
ENV platform=win32
ENV ARCH=i686
ENV MSYSTEM=MINGW32
ENV AR=i686-w64-mingw32.static-ar
ENV AS=i686-w64-mingw32.static-as
ENV CC=i686-w64-mingw32.static-gcc
ENV CXX=i686-w64-mingw32.static-g++
ENV WINDRES=i686-w64-mingw32.static-windres


USER root
WORKDIR /developer
VOLUME /developer

CMD /bin/bash
