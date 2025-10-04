{config, ...}: {
  wisp.programs.rofi = {
    opacity = 100;
    wallpaper = config.stylix.image;
  };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      monitor=Virtual-1,1920x1080,0x0,1
    '';
  };
}
