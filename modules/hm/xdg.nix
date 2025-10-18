{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.xdg;
in {
  options.wisp.xdg = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable XDG base directory specification";
    };

    codeHome = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/code";
      description = "Directory fosr code projects";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg = {
      enable = true;

      portal = {
        enable = true;
        extraPortals = with pkgs; [
          pkgs.xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
          xdg-desktop-portal
        ];
        xdgOpenUsePortal = true;
        # replace with `config.common.default = "hyprland;gtk";`?
        configPackages = with pkgs; [
          pkgs.xdg-desktop-portal-hyprland
          xdg-desktop-portal-gtk
          xdg-desktop-portal
        ];
      };

      mimeApps.enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;

        # Define standard XDG user directories
        desktop = "${config.home.homeDirectory}/Desktop";
        documents = "${config.home.homeDirectory}/Documents";
        download = "${config.home.homeDirectory}/Downloads";
        music = "${config.home.homeDirectory}/Music";
        pictures = "${config.home.homeDirectory}/Pictures";
        publicShare = "${config.home.homeDirectory}/Public";
        templates = "${config.home.homeDirectory}/Templates";
        videos = "${config.home.homeDirectory}/Videos";
      };

      # Define standard XDG base directories
      cacheHome = "${config.home.homeDirectory}/.cache";
      configHome = "${config.home.homeDirectory}/.config";
      dataHome = "${config.home.homeDirectory}/.local/share";
      stateHome = "${config.home.homeDirectory}/.local/state";
    };

    # Set environment variables
    home.sessionVariables = {
      # Base XDG directories
      XDG_CACHE_HOME = config.xdg.cacheHome;
      XDG_CONFIG_HOME = config.xdg.configHome;
      XDG_DATA_HOME = config.xdg.dataHome;
      XDG_STATE_HOME = config.xdg.stateHome;
      XDG_RUNTIME_DIR = "/run/user/$(id -u)";

      # User directories
      XDG_DESKTOP_DIR = config.xdg.userDirs.desktop;
      XDG_DOCUMENTS_DIR = config.xdg.userDirs.documents;
      XDG_DOWNLOAD_DIR = config.xdg.userDirs.download;
      XDG_MUSIC_DIR = config.xdg.userDirs.music;
      XDG_PICTURES_DIR = config.xdg.userDirs.pictures;
      XDG_PUBLICSHARE_DIR = config.xdg.userDirs.publicShare;
      XDG_TEMPLATES_DIR = config.xdg.userDirs.templates;
      XDG_VIDEOS_DIR = config.xdg.userDirs.videos;

      CODE_DIR = cfg.codeHome;

      # Development tools
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      GOPATH = "${config.xdg.dataHome}/go";
      GOBIN = "${config.xdg.dataHome}/go/bin";
      GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";

      # Other programs
      PYTHON_HISTORY = "${config.xdg.dataHome}/python/history";
      WGETRC = "${config.xdg.configHome}/wget/wgetrc";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";

      # FZF configuration
      # FZF_DEFAULT_OPTS = "--layout=reverse --preview-window=right,50%,border-sharp,wrap";
      # ZDOTDIR = "${config.xdg.configHome}/zsh";

      # Additional XDG-related variables
      LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
      PARALLEL_HOME = "${config.xdg.configHome}/parallel";
      SCREENRC = "${config.xdg.configHome}/screen/screenrc";
      ZSH_AUTOSUGGEST_STRATEGY = "history completion";
    };
  };
}
