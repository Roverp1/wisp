-- getting defined in neovim.nix
-- local colors = {
-- 	base00 = "#383a42",
-- 	base01 = "#a0a1a7",
-- 	base05 = "#f3f3f3",
--
-- 	base08 = "#ca1243",
-- 	base0B = "#83a598",
-- 	base0A = "#fe8019",
-- }

local theme = {
	normal = {
		a = { fg = colors.base05, bg = colors.base00 },
		b = { fg = colors.base05, bg = colors.base01 },
		c = { bg = colors.base00 },
		x = { bg = colors.base00 },
		z = { fg = colors.base05, bg = colors.base00 },
	},
	insert = { a = { fg = colors.base00, bg = colors.base0B } },
	visual = { a = { fg = colors.base00, bg = colors.base0A } },
	replace = { a = { fg = colors.base00, bg = colors.base0B } },
}

local empty = require("lualine.component"):extend()
function empty:draw(default_highlight)
	self.status = ""
	self.applied_separator = ""
	self:apply_highlights(default_highlight)
	self:apply_section_separators()
	return self.status
end

-- Put proper separators and gaps between components in sections
local function process_sections(sections)
	for name, section in pairs(sections) do
		local left = name:sub(9, 10) < "x"
		-- for pos = 1, name ~= "lualine_z" and #section or #section - 1 do
		-- 	table.insert(section, pos * 2, { empty, color = { fg = colors.base05, bg = colors.base05 } })
		-- end
		for id, comp in ipairs(section) do
			if type(comp) ~= "table" then
				comp = { comp }
				section[id] = comp
			end
			comp.separator = left and { right = "" } or { left = "" }
		end
	end
	return sections
end

local function search_result()
	if vim.v.hlsearch == 0 then
		return ""
	end
	local last_search = vim.fn.getreg("/")
	if not last_search or last_search == "" then
		return ""
	end
	local searchcount = vim.fn.searchcount({ maxcount = 9999 })
	return "[" .. searchcount.current .. "/" .. searchcount.total .. "]"
end

local function modified()
	if vim.bo.modified then
		return "+"
	elseif vim.bo.modifiable == false or vim.bo.readonly == true then
		return "-"
	end
	return ""
end

require("lualine").setup({
	options = {
		theme = theme,
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = process_sections({
		lualine_a = { "mode" },
		lualine_b = {
			"branch",
			"diff",
			{ "filename", file_status = false, path = 1, color = { bg = colors.base02 } },
			{ modified, color = { bg = colors.base08, fg = colors.base01 } },
			{
				"%w",
				cond = function()
					return vim.wo.previewwindow
				end,
			},
			{
				"%q",
				cond = function()
					return vim.bo.buftype == "quickfix"
				end,
			},
		},
		lualine_c = {},
		lualine_x = { "lsp_status" },
		lualine_y = {
			search_result,
			{
				"diagnostics",
				source = { "nvim" },
				sections = { "error" },
				diagnostics_color = { error = { bg = colors.base08, fg = colors.base01 } },
			},
			{
				"diagnostics",
				source = { "nvim" },
				sections = { "warn" },
				diagnostics_color = { warn = { bg = colors.base0A, fg = colors.base01 } },
			},
			"filetype",
		},
		lualine_z = { "%l:%c" },
	}),
	inactive_sections = {
		lualine_c = { "%f %y %m" },
		lualine_x = {},
	},
})
