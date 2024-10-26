# Initialise waydroid using the vanilla system type
setup-waydroid-vanilla:
    sudo waydroid init --force \
        --system_channel https://ota.waydro.id/system \
        --vendor_channel https://ota.waydro.id/vendor \
        --system_type VANILLA

# Initialise waydroid using the gapps system type
setup-waydroid-gapps:
    sudo waydroid init --force \
        --system_channel https://ota.waydro.id/system \
        --vendor_channel https://ota.waydro.id/vendor \
        --system_type GAPPS

# Initialise waydroid using the foss system type
setup-waydroid-foss:
    sudo waydroid init --force \
        --system_channel https://ota.waydro.id/system \
        --vendor_channel https://ota.waydro.id/vendor \
        --system_type FOSS
