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
    ./kanata.nix
    ./zen-browser.nix
    ./syncthing.nix
    ./transmission.nix

    ./stylix.nix
  ];

  options.wisp = {
    genericLinux = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Only enable genericLinux compatible modules";
    };
  };

  config = {
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
        settings = {
          user.name = "Roverp";
          user.email = "yar.zubaha@proton.me";

          init.defaultBranch = "main";

          alias = {
            lg = "log --oneline --graph";
            ss = "status -s";
          };
        };
      };

      gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
      };

      ssh = {
        enable = true;
        enableDefaultConfig = false;

        settings = {
          "*" = {
            addKeysToAgent = "yes";
          };

          "github.com" = {
            hostname = "github.com";
            user = "git";
            identityFile = "~/.ssh/id_Roverp";
            identitiesOnly = "yes";
          };

          "github-medoyed" = {
            hostname = "github.com";
            user = "git";
            identityFile = "~/.ssh/id_ed25519";
            identitiesOnly = "yes";
          };
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

    stylix = {
      targets = {
        waybar.addCss = false;
        waybar.enable = false;

        tmux.enable = false;
        kitty.enable = false;
      };
    };

    home.stateVersion = "26.05";
  };
}
