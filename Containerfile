FROM ghcr.io/ublue-os/bluefin-dx:stable
COPY system_files/* /
COPY build.sh /tmp/build.sh
RUN --mount=type=cache,dst=/var/cache/rpm-ostree  bash /tmp/build.sh
RUN rm -rf /tmp/* /var/cache/* && dnf clean all