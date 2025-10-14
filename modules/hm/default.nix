{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./dev
    ./wayland
    ./gui

    ./xdg.nix
    ./neovim.nix
    ./kanata.nix
    ./zen-browser.nix
    ./syncthing.nix
  ];

  # home-manager options go here
  home = {
    packages = with pkgs; [
    ];

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
    enableZshIntegration = true;
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
