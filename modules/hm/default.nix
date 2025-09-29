{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./wayland
    ./devPrograms

    ./xdg.nix
    ./neovim.nix
    ./zen-browser.nix
    # ./kitty.nix
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
  };

  stylix = {
    targets = {
      #     qt.enable = false;
      #     gtk.enable = false;
      #     vscode.enable = false;
      #     xresources.enable = false;
      #     sxiv.enable = false;
      #
      zen-browser.profileNames = ["default"];
    };
  };

  home.stateVersion = "25.05";
}
