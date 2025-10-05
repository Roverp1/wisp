# Creating Aceso Rescue ISO

Aceso is a custom NixOS live ISO configured for rescue and recovery operations.

## What is Aceso?

- Bootable rescue ISO based on NixOS
- Terminal-only (no GUI)
- Pre-configured with debugging and recovery tools
- Auto-login as 'aceso' user
- SSH enabled for remote rescue
- Full shell environment (zsh, tmux, neovim)

## Build the ISO

```bash
cd ~/code/nixos_configuration/wisp

# Build ISO image
nix build .#nixosConfigurations.aceso.config.system.build.isoImage
```

**Build time:**
- First build: 20-40 minutes
- Subsequent builds: 5-10 minutes (with cache)

## Find the ISO

```bash
# ISO is in result/iso/
ls -lh result/iso/

# Example output:
# nixos-25.05-x86_64-linux.iso
```

## Write to USB Drive

**WARNING: This will erase all data on the USB drive**

```bash
# Identify USB drive
lsblk

# Write ISO to USB (replace sdX with your USB device)
sudo dd if=result/iso/nixos-*.iso of=/dev/sdX bs=4M status=progress conv=fsync

# Ensure write completes
sync
```

**Verify:**
```bash
# Re-insert USB and check
lsblk
```

Should show USB with ISO partitions.

## Boot Aceso

1. Insert USB drive
2. Enter BIOS/UEFI boot menu (usually F12, F2, or Del)
3. Select USB drive
4. System boots into Aceso

## Using Aceso

### Auto-Login

System automatically logs in as `aceso` user (password: rescue).

### Network Setup

**Ethernet:** Works automatically

**WiFi:**
```bash
nmcli device wifi list
nmcli device wifi connect "SSID" password "PASSWORD"
```

### SSH Access

SSH server is running and accessible:

```bash
# From another machine
ssh aceso@<aceso-ip>
# Password: rescue
```

**Find IP address:**
```bash
ip addr show
```

### Available Tools

**Disk and Recovery:**
- testdisk - Partition recovery
- ddrescue - Data recovery
- smartmontools - Disk health
- lshw, lspci, usbutils - Hardware info

**Network:**
- nmap - Network scanning
- tcpdump - Packet capture
- rsync - File transfer

**System:**
- htop - Process monitor
- neovim - Text editor
- tmux - Terminal multiplexer
- zsh - Shell

### Common Rescue Tasks

**Mount encrypted disk:**
```bash
# Unlock LUKS
sudo cryptsetup open /dev/nvme0n1p2 cryptroot

# Mount btrfs root
sudo mount -o subvol=root /dev/mapper/cryptroot /mnt

# Mount boot
sudo mount /dev/nvme0n1p1 /mnt/boot

# Chroot into system
sudo nixos-enter --root /mnt
```

**Backup data:**
```bash
# Mount external drive
sudo mount /dev/sdX1 /mnt/backup

# Copy data
sudo rsync -av /mnt/home/ /mnt/backup/home/
```

**Check disk health:**
```bash
sudo smartctl -a /dev/nvme0n1
```

**Test disk:**
```bash
sudo badblocks -sv /dev/nvme0n1
```

## Customizing Aceso

Edit `hosts/aceso/configuration.nix` to:
- Add more tools to `environment.systemPackages`
- Change SSH settings
- Modify auto-login user
- Add custom scripts

Then rebuild ISO:
```bash
nix build .#nixosConfigurations.aceso.config.system.build.isoImage
```

## Aceso Configuration

**Location:** `hosts/aceso/configuration.nix`

**Features:**
- Based on `installation-cd-base.nix`
- Wayland/GUI disabled
- NetworkManager enabled
- Auto-login configured
- SSH server running
- Minimal home-manager setup

**User:**
- Username: aceso
- Password: rescue
- Groups: wheel, networkmanager
- Shell: zsh

## Troubleshooting

### ISO won't boot
- Verify USB was written correctly
- Check UEFI/Legacy BIOS mode
- Try different USB port
- Disable Secure Boot

### Network doesn't work
```bash
# Check interface
ip link

# Restart NetworkManager
sudo systemctl restart NetworkManager

# Manual WiFi
sudo wpa_supplicant -B -i wlan0 -c <(wpa_passphrase "SSID" "password")
```

### Can't mount encrypted disk
```bash
# Check LUKS device
sudo cryptsetup luksDump /dev/nvme0n1p2

# Try unlocking with different name
sudo cryptsetup open /dev/nvme0n1p2 rescue
```

## Notes

- Aceso runs entirely in RAM (changes are not persistent)
- Files saved to ISO partitions will persist across reboots
- For persistent storage, use external USB drive
- SSH password authentication is enabled (change if exposing to network)
