{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./boot.nix
    ./stylix.nix
  ];

  environment.systemPackages = with pkgs; [
    # pkgs.vscode - hydenix's vscode version
    # pkgs.userPkgs.vscode - your personal nixpkgs version
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji

    nerd-fonts.jetbrains-mono
  ];

  programs = {
    hyprland = {
      package = pkgs.hyprland;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      enable = true;
      withUWSM = false;
    };

    zsh.enable = true;
  };

  nix = {
    settings.experimenal-features = ["nix-command" "flakes"];

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than +5";
    };
  };
}
