---@module "auto-session"
---@type AutoSession.Config
local config = {
	suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
}

require("auto-session").setup(config)
