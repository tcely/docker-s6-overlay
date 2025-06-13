
variable "S6_OVERLAY_VERSION" { default = "v3.2.0.0" }

target "docker-metadata-action" {}
target "github-metadata-action" {}

group "default" {
    targets = [
        "s6-overlay",
        "s6-overlay-symlinks",
        "s6-overlay-syslogd",
    ]
}

target "s6-overlay" {
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
    ]
    target = "s6-overlay"
    args = {
        S6_OVERLAY_VERSION = "${S6_OVERLAY_VERSION}"
    }
    platforms = [
        "linux/amd64",
        "linux/arm64",
        "linux/riscv64",
        "linux/s390x",
        "linux/386",
        "linux/arm/v7",
        "linux/arm/v6"
    ]
}

target "s6-overlay-symlinks" {
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
        "s6-overlay"
    ]
    target = "s6-overlay-symlinks"
}

target "s6-overlay-syslogd" {
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
        "s6-overlay"
    ]
    target = "s6-overlay-syslogd"
}

# The "release" group is used to build locally in the event that CI/CD is not available.
# Or in most cases, it got rate-limited by Docker Hub.
# e.g: S6_OVERLAY_VERSION=v3.2.0.0 docker buildx bake release --push
group "release" {
    targets = [
        "release-s6-overlay",
        "release-s6-overlay-symlinks",
        "release-s6-overlay-syslogd",
    ]
}
target "release-s6-overlay" {
    inherits = [ "s6-overlay" ]
    tags = [ 
        "docker.io/socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}",
        "ghcr.io/socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}",
    ]
}
target "release-s6-overlay-symlinks" {
    inherits = [ "s6-overlay-symlinks" ]
    tags = [ 
        "docker.io/socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}-symlinks",
        "ghcr.io/socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}-symlinks",
    ]
}
target "release-s6-overlay-syslogd" {
    inherits = [ "s6-overlay-syslogd" ]
    tags = [ 
        "docker.io/socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}-syslogd",
        "ghcr.io/socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}-syslogd",
    ]
}

# The "local" group is used to build for host platforms, usually for testing purposes.
# e.g: S6_OVERLAY_VERSION=v3.2.0.0 docker buildx bake local --load
group "local" {
    targets = [
        "local-s6-overlay",
        "local-s6-overlay-symlinks",
        "local-s6-overlay-syslogd",
    ]
}
target "local-s6-overlay" {
    target = "s6-overlay"
    args = {
        S6_OVERLAY_VERSION = "${S6_OVERLAY_VERSION}"
    }
    tags = [ "socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}"]
}
target "local-s6-overlay-symlinks" {
    inherits = [ "local-s6-overlay" ]
    target = "s6-overlay-symlinks"
    tags = [ "socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}-symlinks"]
}
target "local-s6-overlay-syslogd" {
    inherits = [ "local-s6-overlay" ]
    target = "s6-overlay-syslogd"
    tags = [ "socheatsok78/s6-overlay:${S6_OVERLAY_VERSION}-syslogd"]
}



# Download s6-overlay tarballs for local testing.
target "tarballs" {
  output = ["./tarballs"]
  platforms = ["local"]
  target = "tarballs"
}
