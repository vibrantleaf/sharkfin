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

# stop waydroid
stop-waydroid:
    echo "Stopping the Waydroid Sesson"
    sudo waydroid session stop
    echo "Stopping the Waydroid Servive"
    sudo waydroid service stop

# Unsetup waydroid
remove-waydroid:
    echo "Stopping the Waydroid Sesson"
    sudo waydroid session stop
    echo "Stopping the Waydroid Servive"
    sudo waydroid service stop
    echo "removing waydroid data"
    rm -rf ~/.local/share/waydroid/data/
    echo "removing waydroid desktop files"
    rm -rf ~/.local/share/appications/waydroid.*.desktop
