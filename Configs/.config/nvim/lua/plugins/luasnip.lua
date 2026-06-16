-- all snippet keymaps are defined in blink.lua to avoid conflicts

local ls = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load()

local useState_snippet = ls.snippet("usestate", {
	ls.text_node("const ["),
	ls.insert_node(1, "state"),
	ls.text_node(", set"),
	ls.function_node(function(args)
		local str = args[1][1] or ""
		return str:sub(1, 1):upper() .. str:sub(2)
	end, { 1 }),
	ls.text_node("] = useState("),
	ls.insert_node(2),
	ls.text_node(");"),
	ls.insert_node(0),
})

ls.add_snippets("javascript", { useState_snippet })
ls.add_snippets("typescript", { useState_snippet })
ls.add_snippets("javascriptreact", { useState_snippet })
ls.add_snippets("typescriptreact", { useState_snippet })
