{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.shell.zoxide;
in {
  options = {
    wisp.shell.zoxide.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.shell.zsh.enable;
      description = "Enable zoxide module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zoxide = {
      enable = true;

      enableZshIntegration = config.wisp.shell.zsh.enable;

      options = ["--cmd cd"];
    };
  };
}
