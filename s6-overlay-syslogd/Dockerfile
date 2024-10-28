ARG ALPINE_VERSION=latest
ARG S6_OVERLAY_VERSION=v3.2.0.2

FROM --platform=${BUILDPLATFORM} alpine:${ALPINE_VERSION} AS s6-overlay
RUN apk add --no-cache curl
ARG S6_OVERLAY_VERSION
RUN <<EOF
    set -e
    mkdir /s6-overlay-rootfs
    curl -L https://github.com/just-containers/s6-overlay/releases/download/${S6_OVERLAY_VERSION}/syslogd-overlay-noarch.tar.xz -o /tmp/syslogd-overlay-noarch.tar.xz
    tar  -C /s6-overlay-rootfs -Jxpf /tmp/syslogd-overlay-noarch.tar.xz
EOF

FROM scratch
COPY --from=s6-overlay /s6-overlay-rootfs /
