# s6-overlay-distribution

A container image distribution of [s6-overlay](https://github.com/just-containers/s6-overlay), using [socheatsok78/s6-overlay-installer](https://github.com/socheatsok78/s6-overlay-installer) to create the scratch images all supported architectures.

## Usage

The installer will automatically detect the architecture using `uname -m` of the container and download the appropriate archive.

```Dockerfile
FROM alpine:latest
COPY --link --from=ghcr.io/socheatsok78/s6-overlay-distribution:v3.2.0.0 / /
ENTRYPOINT [ "/init" ]
CMD [ "/bin/sh" ]
```

For `minimal` version, use `ghcr.io/socheatsok78/s6-overlay-distribution:v3.2.0.0-minimal`

```Dockerfile
COPY --link --from=ghcr.io/socheatsok78/s6-overlay-distribution:v3.2.0.0-minimal / /
```

And for `syslogd` version, use `ghcr.io/socheatsok78/s6-overlay-distribution:v3.2.0.0-syslogd`

```Dockerfile
COPY --link --from=ghcr.io/socheatsok78/s6-overlay-distribution:v3.2.0.0-syslogd / /
```

## Versions

The container images are tagged with the version of s6-overlay starting from `v3.2.0.0`. Any future versions will be tagged accordingly.

Please check the [releases](https://github.com/just-containers/s6-overlay/releases) page for the latest version of s6-overlay.
