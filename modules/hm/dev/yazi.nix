{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.programs.yazi;
in {
  options.wisp.programs.yazi = {
    enable = lib.mkOption {
      default = true;
      description = "Enable yazi module";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      file
      ffmpeg
      p7zip
      jq
      poppler
      resvg
    ];

    programs.yazi = {
      enable = true;
      package = pkgs.userPkgs.yazi;

      enableZshIntegration = true;
    };
  };
}
