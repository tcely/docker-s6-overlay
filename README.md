# About

A lightweight container image distribution of [s6-overlay](https://github.com/just-containers/s6-overlay) using an explicitly empty image (`FROM scratch`).

[Source] | [Docker Hub] | [GitHub Container Registry]

## Image

| Registry                    | Image                           |
| --------------------------- | ------------------------------- |
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
# example/Dockerfile

ARG S6_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay:${S6_VERSION} AS s6-overlay

# This is your final image
FROM alpine:latest

# Overlay the s6-overlay files to the root filesystem
# The order of this is up to you, but generally, you want to copy the main s6-overlay first,
# followed by symlinks and syslogd if needed.
COPY --link --from=s6-overlay / /
ENTRYPOINT [ "/init" ]
CMD [ "/bin/sh" ]

# Add any additional packages or configurations you need here
```

This distribution will includes all default binaries and symlinks.
- `s6-overlay-noarch.tar.xz`
- `s6-overlay-${S6_ARCH}.tar.xz`


If you need to include `symlinks` to the `s6-overlay` binaries, you can add the following to your `Dockerfile`:

```diff
ARG S6_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay:${S6_VERSION} AS s6-overlay
+FROM socheatsok78/s6-overlay:${S6_VERSION}-symlinks AS s6-overlay-symlinks

FROM alpine:latest
COPY --link --from=s6-overlay / /
+COPY --link --from=s6-overlay-symlinks / /
```

Also available for `syslogd` service, use `-syslogd` suffix:

```diff
ARG S6_VERSION=v3.2.0.0
FROM socheatsok78/s6-overlay:${S6_VERSION} AS s6-overlay
+FROM socheatsok78/s6-overlay:${S6_VERSION}-syslogd AS s6-overlay-syslogd

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

## Development

Before building the image, ensure you have the following tools installed:
- [Docker](https://www.docker.com/)
- [Buildx](https://docs.docker.com/buildx/working-with-buildx/)
- [tonistiigi/binfmt](https://github.com/tonistiigi/binfmt) - Cross-platform emulator collection distributed with Docker images.

Run the following command to download and verify the `s6-overlay` tarballs:

```bash
$ docker buildx bake download --no-cache
$ docker buildx bake verify --no-cache
```

The `download` target will download the `s6-overlay` tarballs from the official repository, and the `verify` target will check the integrity of the downloaded files. The downloaded files will be stored in the `output` directory.

Build for the host platform, you can use the `local` target:

```bash
# The `local` target will build the image for the host platform only.
# Add `--load` to load the built image into the local Docker daemon.
# Add `--no-cache` to skip the cache and force a rebuild.s
$ docker buildx bake local --load

# Once the build is complete, the following tag will be created:
# - localhost:5000/s6-overlay:v3.2.0.0
# - localhost:5000/s6-overlay:v3.2.0.0-symlinks
# - localhost:5000/s6-overlay:v3.2.0.0-symlinks-syslogd
```

If you want to build for a specific platform, you can use the `--set` flag.
```bash
$ docker buildx bake local --load --set="*.platform=linux/386"
```

Once you have built the image, you can use tool such as [dive](https://github.com/wagoodman/dive) to inspect the image and verify that it contains the expected files.

```bash
$ dive localhost:5000/s6-overlay:v3.2.0.0
```

# License

Licensed under the [MIT License](./LICENSE).
