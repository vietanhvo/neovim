return {
	"glepnir/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		local db = require("dashboard")
		db.setup({
			theme = "hyper",
			config = {
				week_header = {
					enable = true,
				},
				packages = { enable = false },
				shortcut = {
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Files",
						group = "@property",
						action = "Telescope find_files",
						key = "f",
					},
				},
			},
		})
	end,
}
