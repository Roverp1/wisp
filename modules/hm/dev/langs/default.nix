{lib, ...}: {
  imports = [
    ./typst.nix
    ./css.nix
  ];

  options.wisp.langs = {
    frontend = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable frontend langs bundle (css, emmet, ts...)";
    };
  };
}
