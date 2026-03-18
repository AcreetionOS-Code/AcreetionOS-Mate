#!/bin/bash

# AcreetionOS Lite Welcome Popup
# Explains the performance optimizations and Lite features

zenity --info \
    --title="Welcome to AcreetionOS Lite" \
    --width=550 \
    --text="<b>Welcome to AcreetionOS Lite!</b>\n\nThis edition is precision-tuned for maximum efficiency on all hardware, specifically targeting systems with limited resources (1-core CPUs and 2GB RAM).\n\n<b>Key Lite Features:</b>\n• <b>ZRAM Memory:</b> Compressed swap in RAM to double effective memory.\n• <b>OOM Protection:</b> EarlyOOM prevents system freezes during high load.\n• <b>Fast Launch:</b> Preload technology speeds up your favorite apps.\n• <b>Optimized UI:</b> A modern 'Cinnamon-like' feel with reduced overhead.\n\nWhile animations are disabled for speed, you maintain <b>full feature parity</b> with standard AcreetionOS. Every capability is here—just faster and more responsive.\n\n<b>Support:</b> <a href='mailto:natalie@acreetionos.org'>natalie@acreetionos.org</a>\n<b>Discord & Community:</b> <a href='https://acreetionos.org'>https://acreetionos.org</a>\n\nThank you for choosing AcreetionOS!"
