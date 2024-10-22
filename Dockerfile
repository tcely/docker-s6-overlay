ARG ALPINE_VERSION=latest
ARG S6_OVERLAY_VERSION=v3.2.0.2
ARG S6_OVERLAY_INSTALLER=main/s6-overlay-installer.sh

FROM alpine:${ALPINE_VERSION} AS s6-overlay
RUN apk add --no-cache curl
ARG S6_OVERLAY_VERSION
ARG S6_OVERLAY_INSTALLER
ENV S6_OVERLAY_INSTALL_PATH=/s6-overlay-rootfs
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/socheatsok78/s6-overlay-installer/${S6_OVERLAY_INSTALLER})"
ENTRYPOINT [ "/init" ]

FROM scratch
COPY --from=s6-overlay /s6-overlay-rootfs /
