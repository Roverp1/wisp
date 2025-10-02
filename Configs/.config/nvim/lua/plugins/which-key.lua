---@type wk.Opts
local config = {
	delay = 500,

	triggers = {
		{ "<leader>", mode = { "n", "v" } },
		{ "<localleader>", mode = { "n", "v" } },

		-- Built-in Neovim keys that have sub-mappings
		{ "g", mode = { "n", "v" } }, -- g commands (gg, gd, gf, etc.)
		{ "z", mode = { "n", "v" } }, -- z commands (zz, zt, zb, etc.)
		{ "]", mode = { "n", "v" } }, -- ] commands (]c, ]m, etc.)
		{ "[", mode = { "n", "v" } }, -- [ commands ([c, [m, etc.)
		{ "<C-w>", mode = { "n", "v" } }, -- Window commands
		{ '"', mode = { "n", "v" } }, -- Register selection
		{ "'", mode = { "n", "v" } }, -- Mark jumping
		{ "`", mode = { "n", "v" } }, -- Mark jumping (exact position)
	},
}

require("which-key").setup(config)
