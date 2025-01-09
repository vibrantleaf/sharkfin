###############################################################
### Start of vibrant-updater                                ###
### LICENSE: BSD 3-Clause                                   ###
### author: vibrantleaf                                     ###
### from: https://codeberg.org/vibrantleaf/vibrant-updater/ ###
#########@#####################################################

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
FROM quay.io/fedora/fedora-minimal:latest AS vibrantupdater
RUN dnf update -y
COPY --from=go /opt/source /opt/source
RUN mkdir -p /usr/bin/ /usr/share/vibrant-updater/
RUN install -Dm 644 /opt/source/bin/vibrant-updater.bin \
  /usr/bin/vibrant-updater
RUN install -Dm 644 /opt/source/LICENSE.txt \
  /usr/share/vibrant-updater/LICENSE
RUN install -Dm 644 /opt/source/src/VibrantUpdater.desktop \
  /usr/share/vibrant-updater/VibrantUpdater.desktop
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

#####################################################
### Start of Sharkfin                             ###
### LICENSE: Apache-2.0                           ###
### author: Universal Blue team                   ###
### author: vibrantleaf                           ###
### from: https://github.com/vibrantleaf/sharkfin ### 
#####################################################

ARG BASE_IMAGE_NAME=" bazzite-deck-gnome"
ARG FEDORA_MAJOR_VERSION="41"
ARG BASE_IMAGE="ghcr.io/ublue-os/ bazzite-deck-gnome"
ARG UBLUE_TAG=${FEDORA_MAJOR_VERSION}-latest
FROM ghcr.io/ublue-os/bazzite-deck-gnome:latest 
ARG AKMODS_FLAVOR="coreos-stable"
ARG BASE_IMAGE_NAME="bazzite-gnome"
ARG BASE_IMAGE_VENDOR="ublue-os"
ARG IMAGE_NAME="sharkfin"
ARG IMAGE_VENDOR="vibrantleaf"
ARG SHA_HEAD_SHORT="dedbeef"
ARG UBLUE_IMAGE_TAG="latest"
COPY --from=vibrantupdater /usr/share/vibrant-updater /usr/share/vibrant-updater
COPY --from=vibrantupdater /usr/bin/vibrant-updater /usr/bin/vibrant-updater
COPY system_files/* /
RUN sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/fedora-cisco-openh264.repo
RUN sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-free.repo
RUN sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-free-updates.repo
RUN sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree.repo
RUN sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo
RUN dnf install -y rpmfusion-free-release-tainted
RUN dnf install -y rpmfusion-nonfree-release-tainted
RUN sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-free-tainted.repo
RUN sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/rpmfusion-nonfree-tainted.repo
RUN dnf install -y libdvdcss
RUN dnf install -y '*-firmware'
RUN dnf install -y gnome-shell-extension-caffeine
RUN dnf install -y gstreamer1-plugin-libav
#RUN dnf install -y gstreamer1-plugins-bad-freeworld
RUN dnf install -y gstreamer1-plugins-bad-free-extras
RUN dnf install -y gstreamer1-plugins-ugly
RUN dnf install -y gstreamer1-vaapi
RUN dnf install -y libaacs
RUN dnf install -y libbdplus
RUN dnf install -y libbluray
RUN dnf install -y android-tools
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/fedora-cisco-openh264.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:phracek:PyCharm.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_che-nerd-fonts.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_hhd-dev-hhd.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_hikariknight-looking-glass-kvmfr.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_ilyaz-lact.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_kylegospo-bazzite.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_kylegospo-latencyflex.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_kylegospo-obs-vkcapture.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_kylegospo-rom-properties.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_kylegospo-wallpaper-engine-kde-plugin.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_kylegospo-webapp-manager.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_lizardbyte-beta.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_mavit-discover-overlay.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_rodoma92-kde-cdemu-manager.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_rodoma92-rmlint.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_rok-cdemu.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_sentry-switcheroo-control_discrete.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_ublue-os-akmods.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_ublue-os-staging.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/_copr_ycollet-audinux.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/charm.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/fedora-cisco-openh264.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/google-chrome.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/negativo17-fedora-multimedia.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/negativo17-fedora-rar.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/negativo17-fedora-steam.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-free-tainted.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-free-updates-testing.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-free-updates.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-free.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-tainted.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-updates-testing.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree-updates.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/rpmfusion-nonfree.repo
RUN sed -i 'enabled=1/s/enabled=0/' /etc/yum.repos.d/tailscale.repo
RUN echo 'import "/usr/share/vibrant-updater/VibrantUpdater.just"' | tee -a "/usr/share/ublue-os/justfile"
RUN echo 'import "/usr/share/sharkfin/90-sharkfin-waydroid.just"' | tee -a "/usr/share/ublue-os/justfile"
RUN cp -v "/usr/share/vibrant-updater/VibrantUpdater.desktop" "/usr/share/applications/VibrantUpdater.desktop"
RUN sed -i '${BASE_IMAGE_NAME}/s/${IMAGE_NAME}' /usr/share/ublue-os/image-info.json
RUN sed -i '${BASE_IMAGE_VENDOR}/s/${IMAGE_VENDOR}' /usr/share/ublue-os/image-info.json
RUN glib-compile-schemas /usr/share/glib-2.0/schemas
RUN dnf clean all
RUN rm -rfv /tmp/*
RUN rm -rfv /var/cache/*
RUN rm -rfv /var/log/*
RUN mkdir -p /tmp
RUN mkdir -p /var/cache
RUN mkdir -p /var/log
RUN ostree container commit

#######################
### End of Sharkfin ###
#######################
