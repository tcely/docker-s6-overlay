ARG ALPINE_VERSION=latest
ARG S6_OVERLAY_VERSION=v3.2.0.2

FROM alpine:${ALPINE_VERSION} AS s6-overlay
RUN apk add --no-cache curl
ARG S6_OVERLAY_VERSION
RUN <<EOF
    set -e
    S6_ARCH=$(uname -m)
    if [[ "${S6_ARCH}" == "armv7l" ]]; then
        S6_ARCH=arm
    fi
    mkdir /s6-overlay-rootfs
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz -o /tmp/s6-overlay-noarch.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-noarch.tar.xz
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz -o /tmp/s6-overlay-${S6_ARCH}.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/s6-overlay-${S6_ARCH}.tar.xz
EOF

FROM scratch
COPY --from=s6-overlay /s6-overlay-rootfs /
