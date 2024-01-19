return {
	"gbprod/substitute.nvim",
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("substitute").setup({})

		local keymap = vim.keymap
		keymap.set("n", "s", require("substitute").operator, { noremap = true })
		keymap.set("x", "p", require("substitute").visual, { noremap = true })
	end,
}
