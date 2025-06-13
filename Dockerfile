ARG S6_OVERLAY_VERSION=v3.2.0.0

# Tools for building the s6-overlay images
FROM alpine:latest AS internal
RUN apk add --no-cache curl


# Overlay for s6-overlay-noarch.tar.xz & s6-overlay-${arch}.tar.xz
FROM internal AS s6-overlay-rootfs
ARG S6_OVERLAY_VERSION
RUN <<EOF
    set -e
    S6_ARCH=$(uname -m)
    if [[ "${S6_ARCH}" == "armv7l" ]]; then
        S6_ARCH=arm
    fi
    mkdir /s6-overlay-rootfs
    set -x
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz -o /tmp/s6-overlay-noarch.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-noarch.tar.xz
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz -o /tmp/s6-overlay-${S6_ARCH}.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz
EOF
FROM scratch AS s6-overlay
COPY --from=s6-overlay-rootfs /s6-overlay-rootfs /


# Overlay for s6-overlay-symlinks-noarch.tar.xz & s6-overlay-symlinks-arch.tar.xz
FROM --platform=${BUILDPLATFORM} internal AS s6-overlay-rootfs-symlinks
ARG S6_OVERLAY_VERSION
RUN <<EOF
    set -e
    mkdir /s6-overlay-rootfs
    set -x
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz -o /tmp/s6-overlay-symlinks-arch.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz -o /tmp/s6-overlay-symlinks-noarch.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
EOF
FROM scratch AS s6-overlay-symlinks
COPY --from=s6-overlay-rootfs-symlinks /s6-overlay-rootfs /


# Overlay for syslogd-overlay-noarch.tar.xz
FROM --platform=${BUILDPLATFORM} internal AS s6-overlay-rootfs-syslogd
ARG S6_OVERLAY_VERSION
RUN <<EOF
    set -e
    mkdir /s6-overlay-rootfs
    set -x
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/syslogd-overlay-noarch.tar.xz -o /tmp/syslogd-overlay-noarch.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/syslogd-overlay-noarch.tar.xz
EOF
FROM scratch AS s6-overlay-syslogd
COPY --from=s6-overlay-rootfs-syslogd /s6-overlay-rootfs /


# Default image
# This image is used as a base for other images that require s6-overlay.
FROM s6-overlay


# s6-overlay tarballs
FROM scratch AS tarballs
ARG S6_OVERLAY_VERSION
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-aarch64.tar.xz /s6-overlay-aarch64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-arm.tar.xz /s6-overlay-arm.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-armhf.tar.xz /s6-overlay-armhf.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-i486.tar.xz /s6-overlay-i486.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-i686.tar.xz /s6-overlay-i686.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-powerpc64.tar.xz /s6-overlay-powerpc64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-powerpc64le.tar.xz /s6-overlay-powerpc64le.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-riscv64.tar.xz /s6-overlay-riscv64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-s390x.tar.xz /s6-overlay-s390x.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz /s6-overlay-symlinks-arch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz /s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /s6-overlay-x86_64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/syslogd-overlay-noarch.tar.xz /syslogd-overlay-noarch.tar.xz
