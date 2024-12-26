return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		local nvimtree = require("nvim-tree")
		local g = vim.g

		-- recommended settings from nvim-tree documentation
		g.loaded_netrw = 1
		g.loaded_netrwPlugin = 1

		vim.opt.termguicolors = true

		vim.cmd([[ 
      hi NvimTreeSpecialFile guifg=#ff7800, 
      hi NvimTreeWindowPicker gui=bold guibg=#83a598 guifg=#fbf1c7
    ]])

		-- configure nvim-tree
		nvimtree.setup({
			diagnostics = {
				enable = true,
			},
			view = {
				width = {
					max = 40,
				},
			},
			renderer = {
				highlight_git = true,
				group_empty = true,
				indent_markers = {
					enable = true,
				},
			},
			update_focused_file = {
				enable = true,
				ignore_list = {},
			},
		})

		-- set keymaps
		local keymap = vim.keymap
		local nt_api = require("nvim-tree.api")

		keymap.set("n", "<M-o>", nt_api.tree.change_root_to_node)
		keymap.set("n", "<C-b>", nt_api.tree.toggle, { noremap = true, silent = true })
		keymap.set("n", "tf", nt_api.tree.focus)
	end,
}
