{
  config,
  lib,
  ...
}: let
  cfg = config.wisp.programs.fzf;
in {
  options = {
    wisp.programs.fzf.enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.shell.zsh.enable;
      description = "Enable fzf module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fzf = {
      enable = true;

      enableZshIntegration = config.wisp.shell.zsh.enable;
    };
  };
}
