{lib, ...}: {
  imports = [
    ./cli.nix

    ./shell
    ./langs

    ./neovim.nix
    ./kitty.nix
    ./tmux.nix
    ./yazi.nix
    ./opencode.nix
    ./btop.nix

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
