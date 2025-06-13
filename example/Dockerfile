ARG S6_OVERLAY_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay:${S6_OVERLAY_VERSION} AS s6-overlay

# This is your final image
FROM alpine:latest

# Overlay the s6-overlay files to the root filesystem
# The order of this is up to you, but generally, you want to copy the main s6-overlay first,
# followed by symlinks and syslogd if needed.
COPY --link --from=s6-overlay / /
ENTRYPOINT [ "/init" ]
CMD [ "/bin/sh" ]

# Add any additional packages or configurations you need here
