local highlight_yank = vim.api.nvim_create_augroup("highlightYank", {})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = highlight_yank,
	callback = function()
		vim.highlight.on_yank({ timeout = 100 })
	end,
})

-- files with 2 space tabs
vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"html",
		"css",
		"scss",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"json",
		"jsonc",
		"yaml",
		"markdown",
		"nix",
	},
	callback = function()
		vim.bo.tabstop = 2
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		if vim.b[args.buf].disable_autoformat then
			return
		end
		require("conform").format({ bufnr = args.buf })
	end,
})
