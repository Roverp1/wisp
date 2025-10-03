{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.programs.neovim;
in {
  options.wisp.programs.neovim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable neovim module";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = let
      toLua = str: "lua << EOF\n${str}\nEOF\n";
      toLuaFile = file: "lua << EOF\n${builtins.readFile file}\nEOF\n";

      userPlugins = pkgs.userPkgs.vimPlugins;

      base00 = config.lib.stylix.colors.withHashtag.base00;
      base01 = config.lib.stylix.colors.withHashtag.base01;
      base02 = config.lib.stylix.colors.withHashtag.base02;
      base03 = config.lib.stylix.colors.withHashtag.base03;
      base04 = config.lib.stylix.colors.withHashtag.base04;
      base05 = config.lib.stylix.colors.withHashtag.base05;
      base06 = config.lib.stylix.colors.withHashtag.base06;
      base07 = config.lib.stylix.colors.withHashtag.base07;
      base08 = config.lib.stylix.colors.withHashtag.base08;
      base09 = config.lib.stylix.colors.withHashtag.base09;
      base0A = config.lib.stylix.colors.withHashtag.base0A;
      base0B = config.lib.stylix.colors.withHashtag.base0B;
      base0C = config.lib.stylix.colors.withHashtag.base0C;
      base0D = config.lib.stylix.colors.withHashtag.base0D;
      base0E = config.lib.stylix.colors.withHashtag.base0E;
    in {
      enable = true;
      defaultEditor = true;
      vimAlias = true;

      extraPackages = with pkgs;
        [
          gcc
          nodejs

          ripgrep
          fd

          lua-language-server
          nixd

          stylua
          alejandra
          prettierd
          gotools
        ]
        ++ lib.optional config.wisp.programs.yazi.enable pkgs.userPkgs.yazi;

      plugins = with pkgs.vimPlugins;
        [
          {
            plugin = lualine-nvim;
            config = toLua ''
              colors = {
                base00 = "${base00}",
                base01 = "${base01}",
                base02 = "${base02}",
                base03 = "${base03}",
                base04 = "${base04}",
                base05 = "${base05}",
                base06 = "${base06}",
                base07 = "${base07}",
                base08 = "${base08}",
                base09 = "${base09}",
                base0A = "${base0A}",
                base0B = "${base0B}",
                base0C = "${base0C}",
                base0D = "${base0D}",
                base0E = "${base0E}",
              }

              ${builtins.readFile ./../../Configs/.config/nvim/lua/plugins/lualine.lua}
            '';
          }

          {
            plugin = telescope-nvim;
            config = toLua "require(\"telescope\").setup()";
          }

          {
            plugin = nvim-lspconfig;
            config = toLuaFile ./../../Configs/.config/nvim/lua/plugins/lspconfig.lua;
          }

          {
            plugin = userPlugins.blink-cmp;
            config = toLuaFile ./../../Configs/.config/nvim/lua/plugins/blink.lua;
          }

          {
            plugin = luasnip;
            config = toLuaFile ./../../Configs/.config/nvim/lua/plugins/luasnip.lua;
          }

          {
            plugin = conform-nvim;
            config = toLuaFile ./../../Configs/.config/nvim/lua/plugins/conform.lua;
          }

          {
            plugin = which-key-nvim;
            config = toLuaFile ./../../Configs/.config/nvim/lua/plugins/which-key.lua;
          }

          {
            plugin = auto-session;
            config = toLuaFile ./../../Configs/.config/nvim/lua/plugins/auto-session.lua;
          }

          vim-tmux-navigator

          telescope-fzf-native-nvim

          nvim-web-devicons
          plenary-nvim

          {
            plugin = nvim-treesitter.withPlugins (p: [
              p.tree-sitter-nix
              p.tree-sitter-lua
            ]);
            config = toLuaFile ./../../Configs/.config/nvim/lua/plugins/treesitter.lua;
          }
        ]
        ++ lib.optional config.wisp.programs.yazi.enable {
          plugin = yazi-nvim;
          config = toLuaFile ./../../Configs/.config/nvim/lua/plugins/yazi.lua;
        };

      extraLuaConfig = ''
        ${builtins.readFile ./../../Configs/.config/nvim/init.lua}
        ${builtins.readFile ./../../Configs/.config/nvim/lua/config/keymaps.lua}
        ${builtins.readFile ./../../Configs/.config/nvim/lua/config/options.lua}
        ${builtins.readFile ./../../Configs/.config/nvim/lua/plugins/init.lua}
      '';
    };
  };
}
