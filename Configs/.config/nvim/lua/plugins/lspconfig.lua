local M = {}
local lspconfig = require("lspconfig")

local lsp_servers = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = { version = "LuaJIT" },
				workspace = {
					library = {
						vim.fn.expand("$VIMRUNTIME/lua"),
						unpack(vim.api.nvim_list_runtime_paths()), -- works?
						"${3rd}/luv/library",
					},
				},
				telemetry = { enable = false },
			},
		},
	},

	nixd = {
		settings = {
			nixd = {
				nixpkgs = {
					expr = "import <nixpkgs> { }",
				},

				options = {
					nixos = {
						expr = string.format(
							"(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.%s.options",
							vim.uv.os_gethostname()
						),
					},

					home_manager = {
						expr = string.format(
							-- optimal complition for integrated home-manager
							-- allows for completing my custom options (without metadata)
							-- and built in home-manager options (with metadata)
							"((builtins.getFlake (builtins.toString ./.)).nixosConfigurations.%s.options.home-manager.users.value.%s // (builtins.getFlake (builtins.toString ./.)).nixosConfigurations.%s.options.home-manager.users.type.getSubOptions [])",
							vim.uv.os_gethostname(),
							vim.env.USER,
							vim.uv.os_gethostname()
						),
					},
				},
			},
		},
	},
	qmlls = {
		cmd = { "qmlls", "-E" },
	},
	emmet_language_server = {},
	ts_ls = {},
	gopls = {},
	bashls = {
		filetypes = { "sh", "bash", "zsh" },
	},
}

local x = vim.diagnostic.severity

vim.diagnostic.config({
	virtual_text = { prefix = "" },
	signs = { text = { [x.ERROR] = "󰅙", [x.WARN] = "", [x.INFO] = "󰋼", [x.HINT] = "󰌵" } },
	underline = true,
	float = { border = "single" },
})

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
}

M.on_attach = function(_, bufnr)
	local map = vim.keymap.set
	local opts = function(desc)
		return { buffer = bufnr, desc = "LSP " .. desc, silent = true }
	end

	map("n", "gd", vim.lsp.buf.definition, opts("Go to definition"))
	map("n", "gD", vim.lsp.buf.declaration, opts("Go to declaration"))
	map("n", "K", vim.lsp.buf.hover, opts("Hover documentation"))
	-- map("n", "<leader>rn", vim.lsp.buf.rename, opts("Rename")) -- doesnt work
end

for lsp, config in pairs(lsp_servers) do
	local default_config = {
		capabilities = M.capabilities,
		on_attach = M.on_attach,
	}
	local final_config = vim.tbl_extend("force", default_config, config)

	lspconfig[lsp].setup(final_config)
end
