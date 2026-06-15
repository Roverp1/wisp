-- Start Tree-sitter highlighting and indentation for supported filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("treesitter_setup", { clear = true }),
	callback = function(args)
		-- Attempt to start native Tree-sitter highlighting
		pcall(vim.treesitter.start)

		-- Enable Tree-sitter indentation if supported
		local lang = vim.treesitter.language.get_lang(args.match)
		if lang and pcall(vim.treesitter.query.get, lang, "indents") then
			vim.bo.indentexpr = "v:lua.require('nvim-treesitter').indentexpr()"
		end
	end,
})
