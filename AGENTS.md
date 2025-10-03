# Agent Guidelines for Wisp NixOS Configuration

## Build Commands

- Build system: `sudo nixos-rebuild switch --flake '.#wisp'` (note: quotes needed in zsh)
- Test configuration: `sudo nixos-rebuild test --flake '.#wisp'`
- Build without switching: `nixos-rebuild build --flake '.#wisp'`
- Check flake: `nix flake check`
- Update flake inputs: `nix flake update`

## Architecture Overview

This is a native NixOS configuration (no longer using Hydenix wrapper):

- **System packages**: NixOS stable (25.05)
- **User packages**: Available via `pkgs.userPkgs.*` (unstable overlay)
- **Theming**: Stylix for system-wide Base16 theming
- **Desktop**: Hyprland wayland compositor
- **Status bar**: Waybar with DWM-style configuration
- **Terminal**: Kitty with custom theming
- **Editor**: Neovim with LSP, completion, and formatting

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
- Import custom modules using relative paths in `imports = [ ./module.nix ];`
- Use standard NixOS options (no more `hydenix.*` options)
- Custom options under `roverp.*` namespace (e.g., `roverp.shell.zsh.enable`)

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

## Migration Notes

- Migrated from Hydenix wrapper to native NixOS
- Removed dependencies on `hydenix.*` options
- Custom theming via Stylix instead of Hyde theme system
- Direct nixpkgs management with stable/unstable overlay pattern

