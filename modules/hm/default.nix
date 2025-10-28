{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp;
in {
  imports = [
    ./dev
    ./wayland
    ./gui

    ./san # TODO: remove as soon as possible

    ./xdg.nix
    ./neovim.nix
    ./kanata.nix
    ./zen-browser.nix
    ./syncthing.nix
  ];

  options.wisp = {
    genericLinux = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Only enable genericLinux compatible modules";
    };
  };

  # home-manager options go here
  home = {
    sessionVariables = {
      # Default programs
      EDITOR = "nvim";
      BROWSER = "zen";
    };
  };

  programs = {
    git = {
      enable = true;
      userName = "Roverp";
      userEmail = "yar.zubaha@proton.me";

      extraConfig = {
        init.defaultBranch = "main";
      };

      aliases = {
        lg = "log --oneline --graph";
      };
    };

    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };

    ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks."*" = {
        addKeysToAgent = "yes";
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = config.wisp.shell.zsh.enable;
    pinentry.package = pkgs.pinentry-curses;

    # defaultCacheTtl ?
    defaultCacheTtlSsh = 28800;
    maxCacheTtlSsh = 28800;
  };

  gtk.iconTheme = {
    package = pkgs.tela-icon-theme;
    name = "Tela-dark";
  };

  stylix = {
    targets = {
      waybar.addCss = false;
      waybar.enable = false;

      tmux.enable = false;
      kitty.enable = false;
    };
  };

  home.stateVersion = "25.05";
}
