{...}: {
  imports = [
    ./boot.nix
    ./system.nix
    ./wayland.nix
    ./audio.nix
    ./xkb.nix

    ./stylix.nix
  ];
}
