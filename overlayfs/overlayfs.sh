#!/bin/sh

echo Enabling root OverlayFS
whiptail --infobox "Enabling root OverlayFS..." 20 60

echo overlay > /etc/initramfs-tools/modules
update-initramfs -c -k $(uname -r)

sed -i -e 's/^/boot=overlay /g' /boot/firmware/cmdline.txt
sed -i -e 's|\([[:space:]]/[[:space:]].*\)defaults|\1defaults,ro|g' \
       -e 's|\([[:space:]]/boot/firmware[[:space:]].*\)defaults|\1defaults,ro|g' \
       /etc/fstab

raspi-config nonint do_overlayfs 0

cat<<EOF >> /etc/fstab
tmpfs    /tmp            tmpfs   nosuid,nodev      0       0
tmpfs    /var/log        tmpfs   nosuid,nodev      0       0
tmpfs    /var/tmp        tmpfs   nosuid,nodev      0       0
tmpfs    /var/lib/dhcp   tmpfs   nosuid,nodev      0       0
EOF

rm -rf /boot/firmware/overlayfs

echo "Rebooting!"
whiptail --infobox "Rebooting!" 20 60

reboot
