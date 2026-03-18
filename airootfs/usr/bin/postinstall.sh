#!/bin/bash -e

##############################################################################
#
#  PostInstall is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3 of the License, or
#  (at your discretion) any later version.
#
#  PostInstall is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
##############################################################################

echo "Starting AcreetionOS post-installation configuration..."

name=$(ls -1 /home)
echo "Configuring system for user: $name"

echo "Creating user configuration directories..."
mkdir -p /home/$name/.config
mkdir -p /home/$name/.config/caja
mkdir -p /home/$name/.local/share/mate/extensions

echo "Copying MATE desktop configuration..."
cp -r /mate-configs/mate-stuff/.config/* /home/$name/.config/

echo "Setting up autostart applications..."
mkdir -p /home/$name/.config/autostart
cp -r /mate-configs/dd.desktop /home/$name/.config/autostart

echo "Setting file ownership for user configuration..."
chown -R $name:$name /home/$name/.config

echo "Copying shell and system configuration files..."
cp -r /etc/skel/.bashrc /home/$name/.bashrc
cp -r /etc/skel/.zshrc /home/$name/.zshrc
cp -r /etc/skel/.bashrc /root/
cp -r /etc/skel/.zshrc /root/

echo "Configuring system DNS and file attributes..."

echo "Setting up system backgrounds..."
mkdir -p /usr/share/backgrounds
cp -r /backgrounds /usr/share/backgrounds
rm -rf /backgrounds

echo "Configuring sudo password feedback..."
echo "Defaults pwfeedback" | sudo EDITOR='tee -a' visudo >/dev/null 2>&1

echo "Updating system configuration files..."
cp /mkinitcpio/mkinitcpio.conf /etc/mkinitcpio.conf
# Don't copy archiso.conf - it's only for the live ISO
# cp /mkinitcpio/archiso.conf /etc/mkinitcpio.conf.d/archiso.conf

# Create placeholder dm-initramfs.rules for archiso hook compatibility
mkdir -p /usr/lib/initcpio/udev
echo "# Placeholder file for archiso hook compatibility" > /usr/lib/initcpio/udev/11-dm-initramfs.rules
echo "# dm-initramfs rules included for lvm2 and mdadm support" >> /usr/lib/initcpio/udev/11-dm-initramfs.rules

# Remove archiso config if it exists
rm -f /etc/mkinitcpio.conf.d/archiso.conf

echo "Cleaning up temporary files..."
rm -rf /mkinitcpio
rm -rf mate-configs

echo "AcreetionOS post-installation configuration completed successfully!"
