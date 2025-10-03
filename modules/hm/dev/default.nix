{lib, ...}: {
  imports = [
    ./shell

    ./kitty.nix
    ./tmux.nix
    ./yazi.nix
    ./opencode.nix

    ./fzf.nix
  ];

  options.wisp.devBundle = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      desription = "Enabel development bundle";
    };
  };
}
