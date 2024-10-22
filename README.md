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

This distribution will includes all default binaries and symlinks.
- `s6-overlay-noarch.tar.xz`
- `s6-overlay-${S6_ARCH}.tar.xz`
- `s6-overlay-symlinks-noarch.tar.xz`
- `s6-overlay-symlinks-arch.tar.xz`


### For `minimal` version, use `-minimal` suffix:

```Dockerfile
COPY --link --from=ghcr.io/socheatsok78/s6-overlay-distribution:v3.2.0.0-minimal / /
```

This distribution will includes only necessary binaries.
- `s6-overlay-noarch.tar.xz`
- `s6-overlay-${S6_ARCH}.tar.xz`

### And for `syslogd` version, use `-syslogd` suffix:

```Dockerfile
COPY --link --from=ghcr.io/socheatsok78/s6-overlay-distribution:v3.2.0.0-syslogd / /
```

If you are running daemons that cannot log to stderr to take advantage of the s6 logging infrastructure, but hardcode the use of the old `syslog()` mechanism, you can extract this tarball, and your container will run a lightweight emulation of a syslogd daemon, so your syslog logs will be caught and stored to disk.

- `s6-overlay-noarch.tar.xz`
- `s6-overlay-${S6_ARCH}.tar.xz`
- `s6-overlay-symlinks-noarch.tar.xz`
- `s6-overlay-symlinks-arch.tar.xz`
- `syslogd-overlay-noarch.tar.xz`

## Versions

The container images are tagged with the version of s6-overlay starting from `v3.2.0.0`. Any future versions will be tagged accordingly.

Please check the [releases](https://github.com/just-containers/s6-overlay/releases) page for the latest version of s6-overlay.
