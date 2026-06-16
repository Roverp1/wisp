---@module 'blink.cmp'
---@type blink.cmp.Config
local config = {
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},

	snippets = { preset = "luasnip" },

	keymap = {
		preset = "none",

		["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
		["<C-e>"] = {
			"hide",
			function()
				local ls_ok, ls = pcall(require, "luasnip")
				if ls_ok and ls.choice_active() then
					ls.change_choice(1)
					return true
				end
			end,
			"fallback",
		},
		["<CR>"] = { "accept", "fallback" },

		["<Tab>"] = { "select_next", "fallback" },
		["<S-Tab>"] = { "select_prev", "fallback" },

		["<Up>"] = { "select_prev", "fallback" },
		["<Down>"] = { "select_next", "fallback" },
		-- should be "fallback_to_mappings"?
		["<C-p>"] = { "snippet_backward", "fallback" },
		["<C-n>"] = { "snippet_forward", "fallback" },

		["<C-b>"] = { "scroll_documentation_up", "fallback" },
		["<C-f>"] = { "scroll_documentation_down", "fallback" },

		["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
	},
}

require("blink.cmp").setup(config)
