# Agent Guidelines for Wisp NixOS Configuration

## Hosts Overview

This flake defines three NixOS configurations:

- **erebos** - Main laptop with encrypted LUKS+Btrfs, GRUB bootloader, hibernation support
- **wisp** - VM testing environment with disko partitioning, systemd-boot
- **aceso** - Rescue ISO with debugging tools, SSH, terminal-only

## Build Commands

### Per-Host Commands

- Build erebos: `sudo nixos-rebuild switch --flake '.#erebos'`
- Build wisp (VM): `sudo nixos-rebuild switch --flake '.#wisp'`
- Build aceso ISO: `nix build '.#nixosConfigurations.aceso.config.system.build.isoImage'`

### General Commands

- Test configuration: `sudo nixos-rebuild test --flake '.#<hostname>'`
- Build without switching: `nixos-rebuild build --flake '.#<hostname>'`
- Check flake: `nix flake check`
- Update flake inputs: `nix flake update`

Note: Quotes needed in zsh for glob patterns

## Architecture Overview

This is a native NixOS configuration (no longer using Hydenix wrapper):

- **System packages**: NixOS stable (pinned: ddd1826f294a0ee5fdc198ab72c8306a0ea73aa9)
- **User packages**: Available via `pkgs.userPkgs.*` (unstable overlay)
- **Theming**: Stylix for system-wide Base16 theming (gruvbox-dark-hard)
- **Desktop**: Hyprland wayland compositor
- **Status bar**: Waybar with custom configuration
- **Terminal**: Kitty with custom theming
- **Editor**: Neovim with LSP, completion, and formatting
- **Shell**: Zsh with oh-my-posh, fzf integration
- **Disk**: Declarative partitioning with disko (LUKS+Btrfs for erebos)

## Code Style Guidelines

- Use 2-space indentation consistently across all Nix files
- Follow functional attribute set patterns: `{ inputs, ... }: { ... }`
- Import structure: place `inputs` first, then other parameters
- Comments: Use `#` for single-line, place above code blocks for explanations
- String interpolation: Prefer `"${variable}"` over concatenation
- Package references: Use `pkgs.package` (stable) vs `pkgs.userPkgs.package` (unstable)

## Module Structure

- System modules: `modules/system/default.nix` - NixOS configuration
- Home manager modules: `modules/hm/default.nix` - user environment config
- Host configurations: `hosts/<hostname>/configuration.nix` and `disko.nix`
- Shared host config: `hosts/default.nix` - common settings across all hosts
- Import custom modules using relative paths in `imports = [ ./module.nix ];`
- Use standard NixOS options (no more `hydenix.*` options)
- Custom options under `wisp.*` namespace (e.g., `wisp.boot.grub.enable`)
- Legacy options under `roverp.*` namespace (e.g., `roverp.shell.zsh.enable`)

## Package Management

- **Stable packages**: `pkgs.firefox`, `pkgs.git`, etc.
- **Unstable packages**: `pkgs.userPkgs.firefox`, `pkgs.userPkgs.neovim`, etc.
- **System-wide unfree**: Enabled via `nixpkgs.config.allowUnfree = true`

## Configuration Patterns

- **System configuration**: Direct NixOS options (`networking.hostName`, `time.timeZone`)
- **User shell**: System enables zsh, home-manager configures it
- **Theming**: Stylix handles fonts, colors, and application theming
- **Custom modules**: Use option definitions with `lib.mkOption` and `lib.mkIf`

## Error Handling

- Always test with `nixos-rebuild test` before `switch`
- Check hardware compatibility in `configuration.nix` hardware imports
- Validate usernames match between `users.users` and `home-manager.users`
- Use `nix flake check` to validate configuration before building
- Check `home.stateVersion` is set in home-manager configuration

## Disk Configuration (Disko)

### Erebos Layout
- ESP partition: 512M vfat mounted at /boot
- LUKS encrypted partition: remaining space
  - Name: cryptroot
  - Settings: allowDiscards, performance flags
  - Contents: Btrfs with subvolumes
    - @root → /
    - @home → /home
    - @nix → /nix
    - @snapshots → /snapshots
    - @swap → /.swapvol (32G swapfile for hibernation)

### Disko Common Patterns
```nix
# Import disko configuration
(import ./disko.nix { device = "/dev/disk/by-id/..."; })

# LUKS performance flags (runtime, not format-time)
extraOpenArgs = [
  "--perf-no_read_workqueue"
  "--perf-no_write_workqueue"
];
```

**Important:** Use `extraOpenArgs` NOT `settings.cryptsetup` for runtime LUKS flags

## Boot Configuration

### Boot Module Options
- `wisp.boot.enable` - Enable boot module (default: true)
- `wisp.boot.systemdBoot.enable` - Use systemd-boot (default: false)
- `wisp.boot.grub.enable` - Use GRUB (default: false)
- `wisp.boot.grub.enableCryptodisk` - GRUB LUKS support (required for encrypted /boot)

### Host Boot Configurations
- **erebos**: GRUB with cryptdisk (LUKS encrypted root)
- **wisp**: systemd-boot (VM, simpler setup)
- **aceso**: ISO bootloader (installation-cd-base.nix)

### Boot Assertions
- Cannot enable both systemd-boot and GRUB
- Must enable at least one bootloader (except for ISOs)
- aceso disables boot module (uses ISO's built-in bootloader)

## Hibernation Setup (Erebos)

Hibernation requires post-installation configuration:

1. Calculate swap file offset:
   ```bash
   sudo btrfs inspect-internal map-swapfile -r /.swapvol/swapfile
   ```

2. Add to configuration.nix:
   ```nix
   boot = {
     resumeDevice = "/dev/mapper/cryptroot";
     kernelParams = [ "resume_offset=<calculated-number>" ];
   };
   ```

3. Rebuild and test:
   ```bash
   sudo nixos-rebuild switch --flake '.#erebos'
   sudo systemctl hibernate
   ```

## Documentation

User documentation available in `docs/`:
- `installation.md` - Installing NixOS from ISO
- `post-installation.md` - Critical post-install tasks (hibernation, passwords)
- `creating-aceso-iso.md` - Building custom rescue ISO
- `troubleshooting.md` - Common issues and recovery procedures

## Migration Notes

- Migrated from Hydenix wrapper to native NixOS
- Removed dependencies on `hydenix.*` options
- Custom theming via Stylix instead of Hyde theme system
- Direct nixpkgs management with stable/unstable overlay pattern
- Declarative disk partitioning with disko
- Multiple host configurations (laptop, VM, rescue ISO)

## Common Gotchas

- **Disko LUKS flags**: Use `extraOpenArgs` not `settings.cryptsetup`
- **Device paths**: Use `/dev/disk/by-id/` for stability across reboots
- **Hibernation**: Requires manual offset calculation post-install
- **ISO builds**: Disable `wisp.boot.enable` for aceso (has own bootloader)
- **GRUB + LUKS**: Must set `enableCryptodisk = true`
- **Quotes in zsh**: Flake paths need quotes: `'.#hostname'`

