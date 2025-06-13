# About

A container image distribution of [s6-overlay](https://github.com/just-containers/s6-overlay) using an explicitly empty image, especially for building images `FROM scratch`.

[Source] | [Docker Hub] | [GitHub Container Registry]

## Image

| Registry                    | Image                                        |
| --------------------------- | -------------------------------------------- |
| [Docker Hub]                | socheatsok78/s6-overlay         |
| [GitHub Container Registry] | ghcr.io/socheatsok78/s6-overlay |

Following platforms for this image are available:

```bash
$ docker run --rm mplatform/mquery socheatsok78/s6-overlay:v3.2.0.0

# Image: socheatsok78/s6-overlay:v3.2.0.0
#  * Manifest List: Yes (Image type: application/vnd.oci.image.index.v1+json)
#  * Supported platforms:
#    - linux/amd64
#    - linux/arm64
#    - linux/riscv64
#    - linux/s390x
#    - linux/386
#    - linux/arm/v7
#    - linux/arm/v6
```

## Usage

Here a simple example of how to use this image:

```Dockerfile
ARG S6_OVERLAY_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay:${S6_OVERLAY_VERSION} AS s6-overlay

FROM alpine:latest
COPY --link --from=s6-overlay / /
ENTRYPOINT [ "/init" ]
CMD [ "/bin/sh" ]
```

This distribution will includes all default binaries and symlinks.
- `s6-overlay-noarch.tar.xz`
- `s6-overlay-${S6_ARCH}.tar.xz`


If you need to include `symlinks` to the `s6-overlay` binaries, you can add the following to your `Dockerfile`:

```diff
ARG S6_OVERLAY_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay:${S6_OVERLAY_VERSION} AS s6-overlay
+FROM socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}-symlinks AS s6-overlay-symlinks

FROM alpine:latest
COPY --link --from=s6-overlay / /
+COPY --link --from=s6-overlay-symlinks / /
```

Also available for `syslogd` service, use `-syslogd` suffix:

```diff
ARG S6_OVERLAY_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay:${S6_OVERLAY_VERSION} AS s6-overlay
+FROM socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}-syslogd AS s6-overlay-syslogd

FROM alpine:latest
COPY --link --from=s6-overlay / /
+COPY --link --from=s6-overlay-syslogd / /
```

## Versioning

The container images are tagged with the version of s6-overlay starting from `v3.2.0.0`. Any future versions will be tagged accordingly.

Please check the [releases](https://github.com/just-containers/s6-overlay/releases) page for the latest version of s6-overlay.

[Source]: https://github.com/socheatsok78/docker-s6-overlay
[Docker Hub]: https://hub.docker.com/r/socheatsok78/s6-overlay
[GitHub Container Registry]: https://github.com/socheatsok78/docker-s6-overlay/pkgs/container/s6-overlay

# License

Licensed under the [MIT License](https://github.com/socheatsok78/docker-s6-overlay/raw/main/LICENSE).
