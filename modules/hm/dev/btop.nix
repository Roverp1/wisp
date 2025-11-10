{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.btop;
in {
  options.wisp.programs.btop = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.cliBundle.optional;
      description = "Enable btop (resource monitor) module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.btop = {
      enable = true;

      settings = {
        theme_background = false;
        vim_keys = true;
        rounded_corners = false;
        proc_gradient = false;
      };
    };
  };
}
