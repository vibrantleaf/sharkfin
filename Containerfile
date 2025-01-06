##############################################################
### Start of vibrant-updater                               ###
### LICENSE: BSD 3-Clause                                  ###
### author: vibrantleaf                                    ###
### from https://codeberg.org/vibrantleaf/vibrant-updater/ ###
##############################################################

FROM cgr.dev/chainguard/git:latest AS git
RUN git clone https://codeberg.org/vibrantleaf/vibrant-updater.git /home/git/source/
WORKDIR /home/git/source
RUN git fetch --tags
RUN git checkout $(git describe --tags "$(git rev-list --tags --max-count=1)")
FROM cgr.dev/chainguard/go:latest AS go
COPY --from=git /home/git/source/ /opt/source
WORKDIR /opt/source
RUN go build \
  -o /opt/source/bin/vibrant-updater.bin \
  /opt/source/src/vibrant_updater.go
FROM quay.io/fedora/fedora-minimal:latest AS vibrant-updater
RUN dnf update --refresh -y
COPY --from=go /opt/source /opt/source
RUN mkdir -p /usr/bin/ /usr/share/vibrant-updater/
RUN install -Dm 644 /opt/source/bin/vibrant-updater.bin \
  /usr/bin/vibrant-updater
RUN install -Dm 644 /opt/source/LICENSE.txt \
  /usr/share/vibrant-updater/LICENSE
RUN install -Dm 644 /opt/source/src/VibrantUpdater.desktop \
  /usr/share/vibrant-updaterVibrantUpdater.desktop
RUN install -Dm 644 /opt/source/src/VibrantUpdater-sys.service \
  /usr/share/vibrant-updater/VibrantUpdater-sys.service
RUN install -Dm 644 /opt/source/src/VibrantUpdater-sys.timer \
  /usr/share/vibrant-updater/VibrantUpdater-sys.timer
RUN install -Dm 644 /opt/source/src/VibrantUpdater-user.service \
  /usr/share/vibrant-updater/VibrantUpdater-user.service
RUN install -Dm 644 /opt/source/src/VibrantUpdater-user.timer \
  /usr/share/vibrant-updater/VibrantUpdater-user.timer
RUN install -Dm 644 /opt/source/src/VibrantUpdater.just \
  /usr/share/vibrant-updater/VibrantUpdater.just
RUN chmod +x /usr/bin/vibrant-updater
RUN dnf clean all
RUN rm -rf /var/cache/* /tmp/* /opt/* /var/log/*
RUN mkdir -p /var/cache/ /tmp/ /opt/ /var/log/
RUN command -v vibrant-updater
RUN vibrant-updater --help
RUN vibrant-updater --version

##############################
### End of vibrant-updater ###
##############################

###################################
### Start of Sharkfin           ###
### LICENSE: Apache-2.0         ###
### author: Universal Blue team ###
### author: vibrantleaf         ###
###################################

ARG BASE_IMAGE_NAME="bazzite-gnome"
ARG FEDORA_MAJOR_VERSION="41"
ARG BASE_IMAGE="ghcr.io/ublue-os/bazzite-gnome"
ARG UBLUE_TAG=${FEDORA_MAJOR_VERSION}-latest
FROM ghcr.io/ublue-os/bazzite-gnome:latest
ARG AKMODS_FLAVOR="coreos-stable"
ARG BASE_IMAGE_NAME="bazzite-gnome"
ARG IMAGE_NAME="sharkfin"
ARG IMAGE_VENDOR="vibrantleaf"
ARG SHA_HEAD_SHORT="dedbeef"
ARG UBLUE_IMAGE_TAG="latest"
COPY --from vibrant-updater /usr/share/vibrant-updater /usr/share/vibrant-updater
COPY --from vibrant-updater /usr/bin/vibrant-updater /usr/bin/vibrant-updater
COPY system_files/* /
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf remove --assumeyes \
   gnome-shell-extension-search-light \
   gnome-shell-extension-logo-menu \
   gnome-shell-extension-hotedge \
   gnome-shell-extension-caribou-blocker \
   gnome-classic-session \
   gnome-classic-session-xsession \
   gnome-session-xsession \
   yaru-theme \
   containerd.io \
   docker-ce \
   docker-ce-cli \
   docker-buildx-plugin \
   docker-compose-plugin \
   docker-ce-rootless-extras \
   devpod \
   toolbox \
   steamdeck-gnome-presets \
   gnome-shell-extension-bazzite-menu
RUN sed -i '0,/enabled=0/s//enabled=1/' "fedora-cisco-openh264.repo"
RUN sed -i '0,/enabled=0/s//enabled=1/' "rpmfusion-free.repo"
RUN sed -i '0,/enabled=0/s//enabled=1/' "rpmfusion-free-updates.repo"
RUN sed -i '0,/enabled=0/s//enabled=1/' "rpmfusion-nonfree.repo"
RUN sed -i '0,/enabled=0/s//enabled=1/' "rpmfusion-nonfree-updates.repo"
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf install --setopt="install_weak_deps=False" --assumeyes rpmfusion-free-release-tainted
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf install --setopt="install_weak_deps=False" --assumeyes rpmfusion-nonfree-release-tainted
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf swap --setopt="install_weak_deps=False" --assumeyes --allowerasing ffmpeg-free ffmpeg
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf update --setopt="install_weak_deps=False" --assumeyes @multimedia
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf swap --setopt="install_weak_deps=False" --assumeyes mesa-va-drivers mesa-va-drivers-freeworld
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf swap --setopt="install_weak_deps=False" --assumeyes mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf swap --setopt="install_weak_deps=False" --assumeyes mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf swap --setopt="install_weak_deps=False" --assumeyes mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf --repo=rpmfusion-free-tainted install --setopt="install_weak_deps=False" --assumeyes  libdvdcss
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf --repo=rpmfusion-nonfree-tainted install --setopt="install_weak_deps=False" --assumeyes  "*-firmware"
RUN --mount=type=cache,dst=/var/cache/rpm-ostree dnf install --setopt="install_weak_deps=False" --assumeyes \
  gnome-shell-extension-caffeine \
  gstreamer1-plugin-libav \
  gstreamer1-plugins-bad-free-extras \
  gstreamer1-plugins-bad-freeworld \
  gstreamer1-plugins-ugly \
  gstreamer1-vaapi \
  libaacs \
  libbdplus \
  libbluray \
  android-tools
RUN sed -i '0,/enabled=1/s//enabled=0/' "fedora-cisco-openh264.repo"
RUN sed -i '0,/enabled=1/s//enabled=0/' "rpmfusion-free.repo"
RUN sed -i '0,/enabled=1/s//enabled=0/' "rpmfusion-free-updates.repo"
RUN sed -i '0,/enabled=1/s//enabled=0/' "rpmfusion-nonfree.repo"
RUN sed -i '0,/enabled=1/s//enabled=0/' "rpmfusion-nonfree-updates.repo"
RUN sed -i '0,/enabled=1/s//enabled=0/' "rpmfusion-free-tainted.repo"
RUN sed -i '0,/enabled=1/s//enabled=0/' "rpmfusion-nonfree-tainted.repo"
RUN echo 'import "/usr/share/vibrant-updater/VibrantUpdater.just"' | tee -a "/usr/share/ublue-os/justfile"
RUN echo 'import "/usr/share/sharkfin/90-sharkfin-waydroid.just"' | tee -a "/usr/share/ublue-os/justfile"
RUN cp -v "/usr/share/vibrant-updater/VibrantUpdater.desktop" "/usr/share/applications/VibrantUpdater.desktop"
RUN dnf clean all
RUN rm -rfv /tmp/*
RUN rm -rfv /var/cache/*
RUN rm -rfv /var/log/*
RUN mkdir -p /tmp
RUN mkdir -p /var/cache
RUN mkdir -p /var/log

#######################
### End of Sharkfin ###
#######################
