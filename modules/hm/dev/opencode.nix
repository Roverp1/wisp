{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.roverp.programs.opencode;
in {
  options = {
    roverp.programs.opencode.enable = lib.mkOption {
      default = true;
      description = "Enable opencode module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      package = pkgs.userPkgs.opencode;

      settings = {
        theme = lib.mkForce "system"; # leave mkForce or disable stylix module?
        keybinds = {
          leader = "alt+b";
          input_newline = "alt+enter";
        };

        lsp = {
          # doesnt work?
          "qmlls" = {
            command = ["qmlls" "-E"];
            extensions = [".qml"];
          };
        };
      };
    };
  };
}
