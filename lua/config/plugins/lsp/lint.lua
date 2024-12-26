return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	dependencies = {
		"williamboman/mason.nvim",
	},
	config = function()
		require("lint").linters_by_ft = {
			bash = { "shellcheck" },
			dockerfile = { "hadolint" },
			sh = { "shellcheck" },
			yaml = { "yamllint", "actionlint" },
			zsh = { "shellcheck" },
			markdown = { "alex" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("Linting", { clear = true }),
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
