# s6-overlay-distribution

A container image distribution of [s6-overlay](https://github.com/just-containers/s6-overlay)

## Usage

The installer will automatically detect the architecture using `uname -m` of the container and download the appropriate archive.

```Dockerfile
FROM alpine:latest
COPY --link --from=socheatsok78/s6-overlay-distribution:dev / /
ENTRYPOINT [ "/init" ]
CMD [ "/bin/sh" ]
```

> WIP
