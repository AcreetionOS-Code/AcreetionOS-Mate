#!/bin/bash
/usr/bin/acreetion-welcome.sh &

# Apply MATE desktop settings
dconf load / < /etc/mate_settings.dconf
dconf load /org/mate/terminal/ < /etc/terminal-settings

# Setup pacman
if [ -f /usr/bin/pacman2 ]; then
    cp /usr/bin/pacman2 /usr/bin/pacman
fi

# Cleanup autostart for this user
if [ -f "$HOME/.config/autostart/dd.desktop" ]; then
    rm "$HOME/.config/autostart/dd.desktop"
fi

# Ensure root has the latest shell configs
cp /etc/skel/.bashrc /root/
cp /etc/skel/.zshrc /root/
