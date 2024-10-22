
variable "ALPINE_VERSION" { default = "latest" }
variable "S6_OVERLAY_VERSION" { default = "v3.2.0.0" }

target "docker-metadata-action" {}
target "github-metadata-action" {}

group "default" {
    targets = [
        "s6-overlay",
        "s6-overlay-minimal",
        "s6-overlay-syslogd",
    ]
}

target "s6-overlay" {
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
    ]
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        S6_OVERLAY_VERSION = "${S6_OVERLAY_VERSION}"
        S6_OVERLAY_INSTALLER = "main/s6-overlay-installer.sh"
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

target "s6-overlay-minimal" {
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
        "s6-overlay"
    ]
    args = {
        S6_OVERLAY_INSTALLER = "main/s6-overlay-installer-minimal.sh"
    }
}

target "s6-overlay-syslogd" {
    inherits = [
        "docker-metadata-action",
        "github-metadata-action",
        "s6-overlay"
    ]
    args = {
        S6_OVERLAY_INSTALLER = "main/s6-overlay-installer-syslogd.sh"
    }
}

target "dev" {
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        S6_OVERLAY_VERSION = "${S6_OVERLAY_VERSION}"
        S6_OVERLAY_INSTALLER = "main/s6-overlay-installer.sh"
    }
    tags = [
        "socheatsok78/s6-overlay-distribution:dev"
    ]
}
