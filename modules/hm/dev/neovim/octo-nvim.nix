{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.wisp.programs.neovim.octoNvim;
in {
  options.wisp.programs.neovim.octoNvim = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable octo-nvim plugin";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [gh];

    programs.neovim = {
      plugins = with pkgs.vimPlugins; [
        plenary-nvim
        nvim-web-devicons
        telescope-nvim

        {
          plugin = pkgs.vimPlugins.octo-nvim;
          type = "lua";
          config =
            # lua
            ''
              require('octo').setup({
                enable_builtin = true,
                -- use_local_fs = true,
                picker = "telescope",
              });

              vim.keymap.set("n", "<leader>oo", "<cmd>Octo<cr>", {desc = " Octo" })

              vim.treesitter.language.register('markdown', 'octo')
            '';
        }
      ];
    };
  };
}
