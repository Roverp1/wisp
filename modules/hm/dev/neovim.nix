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
    home.packages = with pkgs; [
      lua-language-server
      nixd

      gopls

      qt6.qtdeclarative
    ];

    programs.neovim = let
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
          stylua
          alejandra
          gotools
        ]
        ++ lib.optional config.wisp.programs.yazi.enable yazi;

      plugins = with pkgs.vimPlugins;
        [
          {
            plugin = lualine-nvim;
            config = ''
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

              ${builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/lualine.lua}
            '';
            type = "lua";
          }

          {
            plugin = telescope-nvim;
            config = "require(\"telescope\").setup()";
            type = "lua";
          }

          {
            plugin = nvim-lspconfig;
            config = builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/lspconfig.lua;
            type = "lua";
          }

          {
            plugin = blink-cmp;
            config = builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/blink.lua;
            type = "lua";
          }

          {
            plugin = luasnip;
            config = builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/luasnip.lua;
            type = "lua";
          }

          {
            plugin = conform-nvim;
            config = builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/conform.lua;
            type = "lua";
          }

          {
            plugin = which-key-nvim;
            config = builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/which-key.lua;
            type = "lua";
          }

          {
            plugin = auto-session;
            config = builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/auto-session.lua;
            type = "lua";
          }

          {
            plugin = nvim-autopairs;
            config = "require(\"nvim-autopairs\").setup()";
            type = "lua";
          }

          {
            plugin = nvim-ts-autotag;
            config = "require(\"nvim-ts-autotag\").setup()";
            type = "lua";
          }

          vim-tmux-navigator

          telescope-fzf-native-nvim

          nvim-web-devicons
          plenary-nvim

          {
            plugin = nvim-treesitter.withPlugins (p: [
              p.tree-sitter-nix
              p.tree-sitter-lua
              p.tree-sitter-qmljs
              p.tree-sitter-go
              p.tree-sitter-bash
              p.tree-sitter-typst
              p.tree-sitter-scheme
              p.tree-sitter-python
              p.tree-sitter-kotlin
              p.tree-sitter-c

              p.tree-sitter-javascript
              p.tree-sitter-typescript
              p.tree-sitter-tsx
              p.tree-sitter-json

              p.tree-sitter-css
              p.tree-sitter-scss

              p.tree-sitter-java
              p.tree-sitter-xml
              p.tree-sitter-prisma
            ]);
            config = builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/treesitter.lua;
            type = "lua";
          }
        ]
        ++ lib.optional config.wisp.programs.yazi.enable {
          plugin = yazi-nvim;
          config = builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/yazi.lua;
          type = "lua";
        };

      initLua = ''
        ${builtins.readFile ./../../../Configs/.config/nvim/init.lua}
        ${builtins.readFile ./../../../Configs/.config/nvim/lua/plugins/init.lua}
        ${builtins.readFile ./../../../Configs/.config/nvim/lua/config/keymaps.lua}
        ${builtins.readFile ./../../../Configs/.config/nvim/lua/config/options.lua}
        ${builtins.readFile ./../../../Configs/.config/nvim/lua/config/autocmds.lua}
      '';
    };
  };
}
