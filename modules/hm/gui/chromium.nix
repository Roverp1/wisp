{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.chromium;
in {
  options.wisp.programs.chromium = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.guiBundle.optional;
      description = "Enable chromium module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;

      extensions = [
        {id = "cjpalhdlnbpafiamejdnhcphjbkeiagm";} # ublock origin

        {id = "hfjbmagddngcpeloejdejnfgbamkjaeg";} # vimium c

        {id = "chphlpgkkbolifaimnlloiipkdnihall";} # OneTab
      ];
    };
  };
}
