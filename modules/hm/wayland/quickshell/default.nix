{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.quickshell;
in {
  imports = [
    ./screenshot.nix
  ];

  options.wisp.quickshell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.wayland.hyprland.enable;
      description = "Enable quickshell module (responsible for scripting & desktop ui)";
    };
  };

  config = let
    qs = inputs.quickshell.packages.${pkgs.system}.default;
  in
    lib.mkIf cfg.enable {
      home.packages = [qs];

      home.sessionVariables = {
        QML_IMPORT_PATH = with pkgs;
          lib.concatStringsSep ":" [
            "${qs}/lib/qt-6/qml"
            "${qt6.qtwayland}/lib/qt-6/qml"
            "${qt6.qtdeclarative}/lib/qt-6/qml"
          ];
      };
    };
}
