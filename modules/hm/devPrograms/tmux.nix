{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.roverp.programs.tmux;
in {
  options = {
    roverp.programs.tmux = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable tmux module";
    };
  };

  config = lib.mkIf cfg.enable {
    enable = true;

    prefix = "C-b";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      open
      vim-tmux-navigator
      resurrect
      tmux-sessionx
      tmux-powerline
    ];
  };
}
