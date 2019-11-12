devices=('lavender')

function lunch_devices() {
    add_lunch_combo titanium_${device}-user
    add_lunch_combo titanium_${device}-userdebug
}

for device in ${devices[@]}; do
    lunch_devices
done
