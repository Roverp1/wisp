{...}: {
  imports = [
    ./boot.nix
    ./system.nix
    ./wayland.nix
    ./audio.nix

    ./stylix.nix
  ];
}
