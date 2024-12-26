return {
	"echasnovski/mini.nvim",
	version = "*",
	config = function()
		require("mini.icons").setup()

		MiniIcons.mock_nvim_web_devicons()
	end,
}
