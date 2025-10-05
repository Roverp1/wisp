# NixOS Installation Guide

## Prerequisites

- Target hostname (erebos, vm, etc.)
- Disk device identification
- Network connection

## Boot NixOS ISO

1. Boot from NixOS installation media
2. If using WiFi:
   ```bash
   sudo systemctl start wpa_supplicant
   wpa_cli
   > add_network
   > set_network 0 ssid "YourSSID"
   > set_network 0 psk "password"
   > enable_network 0
   > quit
   ```

## Clone Configuration

```bash
# Install git
nix-shell -p git

# Clone repository
git clone https://github.com/yourusername/nixos_configuration
cd nixos_configuration/wisp
```

## Verify Disk Device

**CRITICAL: Identify correct disk before proceeding**

```bash
# List all disks
lsblk

# Find disk ID (stable across reboots)
ls -l /dev/disk/by-id/
```

**For erebos:**
- Should be: `nvme-KINGSTON_SKC3000S1024G_50026B7686760CFD`
- Verify this matches your actual Kingston NVMe

**For vm:**
- Usually: `/dev/vda` or `/dev/sda`
- Check your VM settings for disk device

**Update configuration if needed:**
```nix
# In hosts/<hostname>/disko.nix or configuration.nix
device = "/dev/disk/by-id/YOUR-ACTUAL-DISK-ID";
```

## Run Disko

**WARNING: This destroys all data on the target disk**

```bash
# For erebos (or your target host)
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- \
  --mode destroy,format,mount ./hosts/erebos/disko.nix
```

**What happens:**
1. Destroys existing partition table
2. Creates new partitions (ESP + LUKS for erebos)
3. Sets up LUKS encryption - **you will be prompted for password**
4. Creates btrfs filesystem and subvolumes
5. Mounts everything to /mnt

**For encrypted systems (erebos):**
- Enter LUKS password when prompted
- **Remember this password** - you'll need it at every boot
- Minimum 8 characters recommended

**Verify mount:**
```bash
mount | grep /mnt
```

**Expected output (erebos):**
```
/dev/mapper/cryptroot on /mnt type btrfs (...)
/dev/nvme0n1p1 on /mnt/boot type vfat (...)
```

## Install NixOS

```bash
sudo nixos-install --flake .#erebos
```

**You will be prompted for:**
- Root password (set even if you won't use root)

**Installation time:**
- First time: 30-60 minutes (downloading packages)
- With binary cache: 10-20 minutes

## Reboot

```bash
# Remove installation media
# Reboot
sudo reboot
```

## First Boot

### For Encrypted Systems (erebos)

**GRUB will prompt:**
```
Enter passphrase for <device>:
```
Type your LUKS password (the one you set during disko).

### Login

**Username:** erebos (or your configured user)
**Password:** laptop (or your initialPassword from configuration.nix)

**IMMEDIATELY change password:**
```bash
passwd
```

### Verify System

```bash
# Check NixOS version
nixos-version

# Check disk layout
lsblk
df -h

# Check swap (won't show until hibernation is configured)
swapon --show
```

## Host-Specific Notes

### Erebos (Laptop)
- **Disk:** Kingston NVMe by-id path
- **Bootloader:** GRUB with LUKS unlock
- **Encryption:** Full disk (except /boot)
- **Swap:** 32GB file for hibernation (needs post-install config)
- **Next:** See post-installation.md for hibernation setup

### VM (Testing/Development)
- **Disk:** Usually /dev/vda or /dev/sda
- **Bootloader:** systemd-boot (simpler)
- **Encryption:** Optional (disko configured if enabled)
- **Swap:** Configured automatically
- **Next:** Ready to use after first boot

## Troubleshooting Installation

### Disko fails with "device busy"
```bash
# Unmount and close
sudo umount -R /mnt
sudo cryptsetup close cryptroot
sudo swapoff -a
# Retry disko
```

### Wrong disk device
```bash
# Re-check device ID
ls -l /dev/disk/by-id/ | grep nvme
# Update in configuration
# Re-run disko
```

### Network timeout during install
```bash
# Test connection
ping nixos.org

# Retry installation
sudo nixos-install --flake .#erebos
```

### LUKS password not accepted at first boot
- Check keyboard layout (default is US)
- Try typing slowly
- Verify Caps Lock is off
- Password is case-sensitive

## Next Steps

After successful first boot:
1. Change initial password
2. For erebos: Configure hibernation (see post-installation.md)
3. Update system: `sudo nixos-rebuild switch --flake .#<hostname>`
