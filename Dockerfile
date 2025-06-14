ARG S6_VERSION=v3.2.0.0

# Tools for building the s6-overlay images
FROM alpine:latest AS internal
RUN apk add --no-cache curl
ARG TARGETARCH TARGETVARIANT
RUN <<EOT
    {
        case "${TARGETARCH}${TARGETVARIANT:+/}${TARGETVARIANT}" in
            (amd64) echo 'x86_64' ;;
            (arm64) echo 'aarch64' ;;
            (riscv64) echo 'riscv64' ;;
            (s390x) echo 's390x' ;;
            (386) echo 'i686' ;;
            (arm/v7) echo 'armhf' ;;
            (arm/v6) echo 'arm' ;;
            (*) echo 1>&2 'Unsupported architecture!' ; exit 1 ;;
        esac
    } >| /S6_ARCH
EOT


# Overlay for s6-overlay-noarch.tar.xz & s6-overlay-${arch}.tar.xz
FROM internal AS s6-overlay-rootfs
ARG S6_VERSION
RUN <<EOT
    set -e
    S6_ARCH=$(cat /S6_ARCH)
    mkdir /s6-overlay-rootfs
    set -x
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-noarch.tar.xz -o /tmp/s6-overlay-noarch.tar.xz
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-noarch.tar.xz.sha256 -o /tmp/s6-overlay-noarch.tar.xz.sha256
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.xz -o /tmp/s6-overlay-${S6_ARCH}.tar.xz
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-${S6_ARCH}.tar.xz.sha256 -o /tmp/s6-overlay-${S6_ARCH}.tar.xz.sha256
    cd   /tmp && sha256sum -c *.sha256
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-noarch.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz
EOT
FROM scratch AS s6-overlay
COPY --from=s6-overlay-rootfs /s6-overlay-rootfs /


# Overlay for s6-overlay-symlinks-noarch.tar.xz & s6-overlay-symlinks-arch.tar.xz
FROM --platform=${BUILDPLATFORM} internal AS s6-overlay-rootfs-symlinks
ARG S6_VERSION
RUN <<EOF
    set -e
    mkdir /s6-overlay-rootfs
    set -x
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz -o /tmp/s6-overlay-symlinks-noarch.tar.xz
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz.sha256 -o /tmp/s6-overlay-symlinks-noarch.tar.xz.sha256
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz -o /tmp/s6-overlay-symlinks-arch.tar.xz
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz.sha256 -o /tmp/s6-overlay-symlinks-arch.tar.xz.sha256
    cd   /tmp && sha256sum -c *.sha256
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-symlinks-noarch.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-symlinks-arch.tar.xz
EOF
FROM scratch AS s6-overlay-symlinks
COPY --from=s6-overlay-rootfs-symlinks /s6-overlay-rootfs /


# Overlay for syslogd-overlay-noarch.tar.xz
FROM --platform=${BUILDPLATFORM} internal AS s6-overlay-rootfs-syslogd
ARG S6_VERSION
RUN <<EOF
    set -e
    mkdir /s6-overlay-rootfs
    set -x
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/syslogd-overlay-noarch.tar.xz -o /tmp/syslogd-overlay-noarch.tar.xz
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/syslogd-overlay-noarch.tar.xz.sha256 -o /tmp/syslogd-overlay-noarch.tar.xz.sha256
    cd   /tmp && sha256sum -c *.sha256
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/syslogd-overlay-noarch.tar.xz
EOF
FROM scratch AS s6-overlay-syslogd
COPY --from=s6-overlay-rootfs-syslogd /s6-overlay-rootfs /


# Default image
# This image is used as a base for other images that require s6-overlay.
FROM s6-overlay


# s6-overlay tarballs
FROM scratch AS tarballs
ARG S6_VERSION
# tarballs
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-aarch64.tar.xz /s6-overlay-aarch64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-arm.tar.xz /s6-overlay-arm.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-armhf.tar.xz /s6-overlay-armhf.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-i486.tar.xz /s6-overlay-i486.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-i686.tar.xz /s6-overlay-i686.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-noarch.tar.xz /s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-powerpc64.tar.xz /s6-overlay-powerpc64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-powerpc64le.tar.xz /s6-overlay-powerpc64le.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-riscv64.tar.xz /s6-overlay-riscv64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-s390x.tar.xz /s6-overlay-s390x.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz /s6-overlay-symlinks-arch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz /s6-overlay-symlinks-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-x86_64.tar.xz /s6-overlay-x86_64.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/syslogd-overlay-noarch.tar.xz /syslogd-overlay-noarch.tar.xz
# checksums
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-aarch64.tar.xz.sha256 /s6-overlay-aarch64.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-arm.tar.xz.sha256 /s6-overlay-arm.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-armhf.tar.xz.sha256 /s6-overlay-armhf.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-i486.tar.xz.sha256 /s6-overlay-i486.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-i686.tar.xz.sha256 /s6-overlay-i686.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-noarch.tar.xz.sha256 /s6-overlay-noarch.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-powerpc64.tar.xz.sha256 /s6-overlay-powerpc64.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-powerpc64le.tar.xz.sha256 /s6-overlay-powerpc64le.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-riscv64.tar.xz.sha256 /s6-overlay-riscv64.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-s390x.tar.xz.sha256 /s6-overlay-s390x.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-symlinks-arch.tar.xz.sha256 /s6-overlay-symlinks-arch.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-symlinks-noarch.tar.xz.sha256 /s6-overlay-symlinks-noarch.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-x86_64.tar.xz.sha256 /s6-overlay-x86_64.tar.xz.sha256
ADD https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/syslogd-overlay-noarch.tar.xz.sha256 /syslogd-overlay-noarch.tar.xz.sha256

FROM alpine:latest AS checksums
RUN --mount=type=bind,source=./tarballs,target=/tmp/tarballs <<EOT
    set -e
    cd /tmp/tarballs
    sha256sum -c *.sha256
EOT
