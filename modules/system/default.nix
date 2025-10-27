{...}: {
  imports = [
    ./virtualisation

    ./boot.nix
    ./system.nix
    ./wayland.nix
    ./audio.nix
    ./xkb.nix
    ./kanata.nix

    ./stylix.nix
  ];
}
