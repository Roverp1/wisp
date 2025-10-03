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
            plugin = lualine-nvim;
            config = toLuaFile ./../../Configs/.config/nvim/lua/plugins/lualine.lua;
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
