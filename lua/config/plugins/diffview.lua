return {
	"sindrets/diffview.nvim",
	dependencies = { "echasnovski/mini.icons" },
	event = { "BufReadPost", "BufNewFile" },
	config = function()
		require("diffview").setup({
			view = {
				merge_tool = {
					layout = "diff3_mixed",
					disable_diagnostics = true,
				},
			},
		})
	end,
}
