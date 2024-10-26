#!/bin/bash
set -ouex pipefail
RELEASE="$(rpm -E %fedora)"

# setup COPRs & RPM repos
# get new repos & coprs
curl -Lo /etc/yum.repos.d/_copr_matte-schwartz_sunshine.repo \
  https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-${RELEASE}/matte-schwartz-sunshine-fedora-${RELEASE}.repo
curl -Lo /etc/yum.repos.d/_copr_zeno-scrcpy.repo \
  https://copr.fedorainfracloud.org/coprs/zeno/scrcpy/repo/fedora-${RELEASE}/zeno-scrcpy-fedora-${RELEASE}.repo

rpm-ostree install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm

# get rpmfusion tainted repos
rpm-ostree install rpmfusion-free-release-tainted
rpm-ostree install rpmfusion-nonfree-release-tainted
