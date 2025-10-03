{
  config,
  lib,
  ...
}: {
  imports = [
    ./rofi.nix
  ];

  options.wisp.guiBundle = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.wayland.enable;
      description = "Enable GUI bundle";
    };
  };
}
