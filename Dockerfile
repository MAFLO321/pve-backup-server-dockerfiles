FROM debian:bullseye AS builder

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential git-core \
    lintian pkg-config quilt patch cargo \
    nodejs node-colors node-commander \
    libudev-dev libapt-pkg-dev \
    libacl1-dev libpam0g-dev libfuse3-dev \
    libsystemd-dev uuid-dev libssl-dev \
    libclang-dev libjson-perl libcurl4-openssl-dev \
    dh-exec curl ca-certificates

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

WORKDIR /src

# Clone all sources
ARG VERSION=master
COPY versions/${VERSION}/ /patches/
RUN /patches/clone.bash

# Apply all patches
COPY scripts/ /scripts/
RUN /scripts/apply-patches.bash /patches/server/*.patch
RUN /scripts/strip-cargo.bash

# A first required dep
RUN apt-get -y build-dep ${PWD}/pve-eslint
RUN cd pve-eslint/ && make dinstall

# Install dev dependencies of widget toolkit
RUN apt-get -y build-dep ${PWD}/proxmox-widget-toolkit
RUN cd proxmox-widget-toolkit/ && make deb && dpkg -i proxmox-widget-toolkit-dev*.deb && mv *.deb ../

# Deps for all rest
RUN apt-get build-dep -y --no-install-recommends \
    ${PWD}/proxmox-backup \
    ${PWD}/proxmox-mini-journalreader \
    ${PWD}/extjs \
    ${PWD}/proxmox-i18n \
    ${PWD}/pve-xtermjs \
    ${PWD}/libjs-qrcodejs \
    ${PWD}/proxmox-acme

# Compile ALL
RUN . ${HOME}/.cargo/env && cd proxmox-backup/ && dpkg-buildpackage -us -uc -b
RUN cd extjs/ && make deb && mv *.deb ../
RUN cd proxmox-i18n/ && make deb && mv pbs-i18n*.deb ../
RUN cd pve-xtermjs/ && dpkg-buildpackage -us -uc -b
RUN cd proxmox-mini-journalreader/ && make deb && mv *.deb ../
RUN cd libjs-qrcodejs/ && make deb && mv *.deb ../
RUN cd proxmox-acme/ && DEB_BUILD_OPTIONS=nocheck make deb && mv libproxmox-acme-plugins*.deb ../

#=================================

FROM scratch AS exporter
COPY --from=builder /src/*.deb /

#=================================

FROM debian:bullseye
COPY --from=builder /src/*.deb /src/

# Install all packages
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get install -y --no-install-recommends \
       ca-certificates runit \
       $(find /src -name '*.deb' -not -name '*dev*' -not -name '*dbgsym*') \
    && rm -rf /src \
    && rm -rf /var/lib/apt/lists/*

COPY runit/ /runit/
CMD ["runsvdir", "/runit"]
