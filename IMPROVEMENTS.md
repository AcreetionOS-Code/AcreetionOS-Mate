# AcreetionOS Improvements & Optimizations

This document details the technical improvements, architectural optimizations, and system enhancements implemented in AcreetionOS (specifically the **Lite/MATE Edition**).

## 🏗️ Build System Enhancements

AcreetionOS has transitioned from a standard Archiso profile to a custom, multi-architecture build environment.

- **Multi-Architecture Support**: Native build support for `x86_64`, `i686`, `aarch64` (ARM64), `armv7h` (ARM32), and `riscv64`.
- **Custom Build Wrapper**: Use of `mkarchiso_wrapper` to handle parallelized builds (`-j $(nproc)`) and architecture-specific `pacman` configurations.
- **Automated Environment**: The `build-mate.sh` script handles pre-build cleanup, directory staging, and environment variable exports (like `PACMAN_OPTS="--overwrite '*'"`).
- **ISO Compression**: Switched to **SquashFS with XZ compression** (1MB dictionary size) to ensure the smallest possible ISO footprint without sacrificing decompression speed on low-power CPUs.

## ⚡ Performance Optimizations (Lite Focus)

To support the target hardware (1-core CPU, 2GB RAM), several kernel and userspace tunables have been applied:

- **ZRAM Memory Management**: Implementation of `zram-generator` with a smart-capping logic `min(ram / 2, 2048)`. This prevents excessive allocation on high-RAM systems while ensuring 2GB systems have enough compressed swap.
- **Out-of-Memory (OOM) Protection**: Inclusion and activation of `earlyoom` to proactively kill runaway processes, preventing total system lockups during high memory pressure.
- **Application Pre-caching**: `preload` is enabled by default to monitor user behavior and pre-cache frequent applications, significantly reducing launch times on single-core systems.
- **Kernel Tuning**: `vm.swappiness` is set to 100 to prioritize the use of compressed ZRAM over physical disk swap.

## 🖥️ Desktop & UX Improvements

The MATE desktop environment has been heavily modified to provide a "Cinnamon-like" experience with a fraction of the overhead.

- **Consolidated Configuration**: Merged disparate dconf settings into a single master `/etc/mate_settings.dconf`, ensuring a consistent experience between the live ISO and installed system.
- **Window Management**: 
  - **Disabled Marco Compositing**: Significantly reduces GPU/CPU cycles by removing window shadows and transparency.
  - **Reduced Resources Mode**: Enabled MATE's native low-resource mode for window drawing.
  - **No Animations**: Global interface animations are disabled for an instantaneous UI response.
- **Modern Interface**: Integration of the **Brisk Menu** (search-centric) and a streamlined panel layout (36px) for a modern aesthetic.
- **Hardware Interaction**: Enabled `numlockx` by default in the LightDM greeter for immediate numeric entry.
- **Theming & Branding**: Full transition to the **Arc-Dark** GTK theme and **Papirus-Dark** icons, paired with the custom Acreetion Galaxy wallpaper.

## 🐚 Shell & CLI Environment

AcreetionOS now provides a standardized and optimized command-line experience.

- **Standardized Deployment**: Shell configurations are now managed via `/etc/skel/`, ensuring consistent `.bashrc` and `.zshrc` deployment for both `root` and new users.
- **Optimized Zsh Support**: Added a custom, lightweight `.zshrc` with intelligent completions, history management, and a high-visibility prompt.
- **Consolidated Fastfetch**: System branding (AcreetionOS.txt) is now centralized in `/etc/`, and `fastfetch` is configured to use it by default across all shells.
- **Safe Aliases**: Removed dangerous or redundant shell aliases (like `sudo tee`) to ensure predictable system behavior.

## 🛡️ Stability & Hardware Support

- **Firmware Inclusion**: Added `mkinitcpio-firmware` and enabled `amd-ucode` + `intel-ucode` for broader CPU and hardware support.
- **Initramfs Reliability**: Added `mdadm_udev` and `lvm2` to `mkinitcpio` HOOKS to support RAID and LVM installations.
- **Filesystem Optimizations**: 
  - **EXT4 (Preferred)**: Optimized with `commit=60` and `noatime` to reduce disk I/O and extend hardware lifespan.
  - **BTRFS (Optional)**: Configured with `compress-force=zstd:1` and `discard=async` for maximum performance.
- **Legacy Graphics Support**: Optimized drivers for NVIDIA, AMD, and Intel are included in the default overlay to ensure out-of-the-box compatibility with legacy hardware.

## 📋 Summary of Key Transitions

| Component | Old Standard | New AcreetionOS Lite |
|-----------|--------------|----------------------|
| **Base** | Generic Arch | Optimized AcreetionOS |
| **Terminal** | GNOME Console | MATE Terminal (Customized) |
| **Compression** | ZSTD / EROFS | SquashFS + XZ (Max Compression) |
| **Swap** | Disk-based | ZRAM (Capped @ 2GB) |
| **Menu** | MATE Default | Brisk Menu (Searchable) |
| **Shells** | Bash Only | Optimized Bash & Zsh |

---
*Last Updated: March 2026*
