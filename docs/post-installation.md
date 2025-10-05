# Post-Installation Configuration

## Critical Tasks

### 1. Change Initial Password

**SECURITY CRITICAL - Do this immediately:**

```bash
passwd
```

Enter new strong password when prompted.

## Hibernation Setup (Erebos Only)

If your host uses encrypted btrfs swap file (erebos), hibernation requires additional configuration.

### Calculate Swap File Offset

**This is REQUIRED for hibernation to work:**

```bash
sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
```

**Example output:**
```
1234567
```

This number is your swap file offset. Write it down.

### Update Configuration

Edit `hosts/erebos/configuration.nix`:

```nix
boot = {
  resumeDevice = "/dev/mapper/cryptroot";
  kernelParams = [
    "resume_offset=1234567"  # Replace with YOUR actual number
  ];
};
```

**Rebuild system:**

```bash
cd ~/code/nixos_configuration/wisp
sudo nixos-rebuild switch --flake .#erebos
```

### Test Hibernation

```bash
# Save all your work first!

# Test hibernate
sudo systemctl hibernate
```

**What should happen:**
1. System saves state to swap
2. Powers off completely
3. When you power on:
   - GRUB prompts for LUKS password
   - System resumes with all programs/windows restored

**Verify after resume:**
```bash
journalctl -b | grep -i "resuming from hibernation"
```

Should show messages about resuming from hibernation.

### If Hibernation Fails

**Check swap is active:**
```bash
swapon --show
```

Should show `/.swapvol/swapfile`.

**Check kernel parameters:**
```bash
cat /proc/cmdline | grep resume
```

Should show `resume=/dev/mapper/cryptroot` and `resume_offset=<your-number>`.

**Recalculate offset if needed:**
```bash
sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
```

If number is different, update configuration.nix and rebuild.

## Verify System Configuration

### Check Swap

```bash
# Show swap devices
swapon --show

# Show memory/swap usage
free -h
```

### For Encrypted Systems - Verify LUKS Settings

```bash
# Check LUKS configuration
sudo cryptsetup luksDump /dev/nvme0n1p2

# Verify TRIM/discard is enabled
sudo dmsetup table cryptroot | grep allow_discards
```

Should show `allow_discards` in output.

### Check Btrfs

```bash
# Filesystem usage
sudo btrfs filesystem usage /

# Verify compression
sudo compsize /
```

### Test TRIM (SSD only)

```bash
sudo fstrim -av
```

Should show trimmed bytes for your filesystems.

## Update System

```bash
cd ~/code/nixos_configuration/wisp

# Update flake inputs
nix flake update

# Rebuild with new packages
sudo nixos-rebuild switch --flake .#<hostname>
```

## Backup Critical Data

### LUKS Header Backup (Encrypted Systems)

**IMPORTANT: If LUKS header is corrupted, your data is LOST**

```bash
# Backup header
sudo cryptsetup luksHeaderBackup /dev/nvme0n1p2 \
  --header-backup-file ~/luks-header-backup.img

# Copy to external storage
cp ~/luks-header-backup.img /mnt/external/
```

Store this file somewhere safe (external drive, cloud storage).

### Configuration Backup

Your NixOS configuration is in git. Make sure to push changes:

```bash
cd ~/code/nixos_configuration
git add .
git commit -m "Initial erebos configuration"
git push
```

## Verification Checklist

After completing post-installation:

- [ ] Password changed from initial
- [ ] Hibernation works (if applicable)
- [ ] Swap is active
- [ ] TRIM working (SSD)
- [ ] System updated
- [ ] LUKS header backed up (encrypted systems)
- [ ] Configuration pushed to git

## Next Steps

System is now fully configured and ready for use.

For problems, see `troubleshooting.md`.
