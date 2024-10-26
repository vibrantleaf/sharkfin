#!/bin/bash
set -ouex pipefail
RELEASE="$(rpm -E %fedora)"

sed -i 's/bluefin-dx/sharkfin/g' /usr/share/ublue-os/image-info.json
sed -i 's/ublue-os/vibrantleaf/g' /usr/share/ublue-os/image-info.json
sed -i 's/ghcr.io/ublue-os/bluefin-dx/ghcr.io/vibrantlef/sharkfin/g' /usr/share/ublue-os/image-info.json