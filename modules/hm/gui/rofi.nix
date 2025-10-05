{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.programs.rofi;
  inherit (config.lib.formats.rasi) mkLiteral;

  colors = config.lib.stylix.colors;

  mkRgba = opacity: color: let
    c = colors;
    r = c."${color}-rgb-r";
    g = c."${color}-rgb-g";
    b = c."${color}-rgb-b";
  in
    mkLiteral "rgba ( ${r}, ${g}, ${b}, ${opacity} % )";

  mkRgb = mkRgba "100";
in {
  options.wisp.programs.rofi = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.wisp.guiBundle.enable;
      description = "Enable rofi module";
    };

    wallpaper = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Path to wallpaper for rofi background";
    };

    opacity = lib.mkOption {
      type = lib.types.int;
      default = 100;
      description = "Background opacity percentage (0-100)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;

      font = "${config.stylix.fonts.monospace.name} ${toString config.stylix.fonts.sizes.popups}";

      extraConfig = {
        modi = "drun";
        show-icons = true;
        display-drun = " ";
        drun-display-format = "{name}";
        icon-theme = "Tela-dark";
      };

      theme = let
        bgOpacity = toString cfg.opacity;
      in {
        "*" = {
          background = mkRgba bgOpacity "base00";
          lightbg = mkRgba bgOpacity "base01";
          red = mkRgba bgOpacity "base08";
          blue = mkRgba bgOpacity "base0D";
          lightfg = mkRgba bgOpacity "base06";
          foreground = mkRgba bgOpacity "base05";

          background-color = mkRgb "base00";
          separatorcolor = mkLiteral "@foreground";
          border-color = mkLiteral "@foreground";

          selected-normal-foreground = mkLiteral "@lightbg";
          selected-normal-background = mkLiteral "@lightfg";
          selected-active-foreground = mkLiteral "@background";
          selected-active-background = mkLiteral "@blue";

          normal-foreground = mkLiteral "@foreground";
          normal-background = mkLiteral "@background";
          active-foreground = mkLiteral "@blue";
          active-background = mkLiteral "@background";

          alternate-normal-foreground = mkLiteral "@foreground";
          alternate-normal-background = mkLiteral "@lightbg";
          alternate-active-foreground = mkLiteral "@blue";
          alternate-active-background = mkLiteral "@lightbg";

          normal-text = mkRgb "base05";
          selected-normal-text = mkRgb "base01";
          selected-active-text = mkRgb "base00";
          active-text = mkRgb "base0D";
          alternate-normal-text = mkRgb "base05";
          alternate-active-text = mkRgb "base0D";
        };

        window = {
          height = mkLiteral "30em";
          width = mkLiteral "58em";
          transparency = "real";
          background-color = mkLiteral "@background";
          border-color = mkLiteral "@border-color";
        };

        mainbox = {
          padding = mkLiteral "0.8em";
          orientation = mkLiteral "horizontal";
          children = map mkLiteral ["inputbar" "listbox"];
          background-color = mkLiteral "#00000003";
        };

        inputbar = {
          width = mkLiteral "28.5em";
          expand = false;
          background-color = mkRgba "30" "base00";
          border-radius = mkLiteral "1em 0em 0em 1em";
          children = map mkLiteral ["prompt" "entry"];
          padding = mkLiteral "1.5em";
          spacing = mkLiteral "0.5em";
        };

        prompt = {
          enabled = true;
          text-color = mkLiteral "@foreground";
          padding = mkLiteral "0.5em 1em 0.5em 0em";
        };

        entry = {
          enabled = true;
          placeholder = "Search applications...";
          placeholder-color = mkLiteral "@alternate-normal-foreground";
          text-color = mkLiteral "@foreground";
          cursor = mkLiteral "text";
        };

        listbox = {
          spacing = mkLiteral "0em";
          padding = mkLiteral "1em";
          background-color = mkLiteral "@background";
          border-radius = mkLiteral "0em 1em 1em 0em";
          children = map mkLiteral ["listview"];
        };

        listview = {
          padding = mkLiteral "1em 2em";
          columns = 1;
          lines = 8;
          cycle = true;
          scrollbar = false;
          background-color = mkLiteral "transparent";
          border-color = mkLiteral "@separatorcolor";
        };

        element = {
          spacing = mkLiteral "1em";
          padding = mkLiteral "0.5em 0.5em 0.5em 1.5em";
          cursor = mkLiteral "pointer";
          border-radius = mkLiteral "0.5em";
        };

        element-text = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
          vertical-align = mkLiteral "0.5";
        };

        element-icon = {
          size = mkLiteral "2.2em";
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };

        "element normal.normal" = {
          background-color = mkLiteral "@normal-background";
          text-color = mkLiteral "@normal-text";
        };

        "element selected.normal" = {
          background-color = mkLiteral "@selected-normal-background";
          text-color = mkLiteral "@selected-normal-text";
        };

        "element alternate.normal" = {
          background-color = mkLiteral "@alternate-normal-background";
          text-color = mkLiteral "@alternate-normal-text";
        };

        textbox.text-color = mkLiteral "@normal-text";
      };
    };

    stylix.targets.rofi.enable = false;
  };
}
