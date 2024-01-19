return {
	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		build = function()
			require("dbee").install()
		end,
		config = function()
			local dbee = require("dbee")
			dbee.setup()

			local keymap = vim.keymap
			keymap.set("n", "<leader>d", dbee.toggle)
		end,
	},
}
