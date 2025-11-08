{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.roverp.programs.opencode;

  # TODO: remove this
  pinnedPackage = inputs.nixpkgs-opencode.legacyPackages.${"x86_64-linux"}.opencode;
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
      package = pinnedPackage;

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
