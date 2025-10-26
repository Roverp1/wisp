local prittier = { "local_prettier", "prettierd", "prettier", stop_after_first = true }
local util = require("conform.util")

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		go = { "goimports", "gofmt" },
		qml = { "qmlformat" },
		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },
		css = prittier,
		html = prittier,
		javascript = prittier,
		typescript = prittier,
		javascriptreact = prittier,
		typescriptreact = prittier,
		markdown = prittier,
		json = prittier,
		jsonc = prittier,
		yaml = prittier,
	},

	formatters = {
		local_prettier = {
			command = util.find_executable({
				"./node_modules/.bin/prettier",
			}, "prettier"),
			args = { "--stdin-filepath", "$FILENAME" },
			stdin = true,
			cwd = util.root_file({ "package.json", ".git" }),
		},
	},
})
