#!/usr/bin/env bash
set -xout pipefail
RELEASE="$(rpm -E %fedora)"

# setup COPRs & RPM repos
# get new repos & coprs
curl -Lo /etc/yum.repos.d/_copr_matte-schwartz_sunshine.repo \
  https://copr.fedorainfracloud.org/coprs/matte-schwartz/sunshine/repo/fedora-${RELEASE}/matte-schwartz-sunshine-fedora-${RELEASE}.repo
curl -Lo /etc/yum.repos.d/_copr_zeno-scrcpy.repo \
  https://copr.fedorainfracloud.org/coprs/zeno/scrcpy/repo/fedora-${RELEASE}/zeno-scrcpy-fedora-${RELEASE}.repo

dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${RELEASE}.noarch.rpm \
  https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${RELEASE}.noarch.rpm

# enable repos & coprs
declare -a enable_list=("_copr_matte-schwartz_sunshine.repo"
                        "_copr_zeno-scrcpy.repo"
                        "fedora-cisco-openh264.repo"
                        "rpmfusion-free.repo"
                        "rpmfusion-free-updates.repo"
                        "rpmfusion-nonfree.repo"
                        "rpmfusion-nonfree-updates.repo")
for i in "${enable_list[@]}"
do
  if [ -f /etc/yum.repos.d/$i ]
  then
    sed -i '0,/enabled=0/s//enabled=1/' /etc/yum.repos.d/$i
  else
    printf "ERROR /etc/yum.repos.d/$i is missing"
    exit 1
  fi
done

# disable repos & coprs
declare -a disable_list=("rpmfusion-nonfree-steam.repo"
                         "rpmfusion-nonfree-updates-testing.repo"
                         "rpmfusion-nonfree-updates-testing.repo")
for i in "${disable_list[@]}"
do
  if [ -f /etc/yum.repos.d/$i ]
  then
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/$i
  else
    printf "ERROR /etc/yum.repos.d/$i is missing"
    exit 1
  fi
done


# get rpmfusion tainted repos
dnf install rpmfusion-free-release-tainted
dnf install rpmfusion-nonfree-release-tainted


git clone https://github.com/fabiscafe/game-devices-udev.git /var/tmp/game-devices-udev
git clone https://github.com/wget/realtek-r8152-linux.git /var/tmp/realtek-r8152-udev
cp -rfv /var/tmp/game-devices-udev/*.rules /usr/share/ublue-os/udev-rules/etc/udev/rules.d
cp -rfv /var/tmp/realtek-r8152-udev/*.rules /usr/share/ublue-os/udev-rules/etc/udev/rules.d
rm -rfv /var/tmp/game-devices-udev /var/tmp/realtek-r8152-udev

dnf remove \
   gnome-shell-extension-search-light \
   gnome-shell-extension-search-light \
   gnome-shell-extension-logo-menu \
   gnome-classic-session \
   gnome-classic-session-xsession \
   yaru-theme \
   containerd.io \
   docker-ce \
   docker-ce-cli \
   docker-buildx-plugin \
   docker-compose-plugin \
   docker-ce-rootless-extras \
   devpod \
   toolbox