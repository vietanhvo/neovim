return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"simrat39/rust-tools.nvim",
	},
	config = function()
		local function isempty(s)
			return s == nil or s == ""
		end

		local function use_if_defined(val, fallback)
			return val ~= nil and val or fallback
		end

		-- custom python provider
		local conda_prefix = os.getenv("CONDA_PREFIX")
		if not isempty(conda_prefix) then
			vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, conda_prefix .. "/bin/python")
			vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, conda_prefix .. "/bin/python")
		else
			vim.g.python_host_prog = use_if_defined(vim.g.python_host_prog, "python")
			vim.g.python3_host_prog = use_if_defined(vim.g.python3_host_prog, "python3")
		end

		---@diagnostic disable: undefined-global
		-- Mappings.
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		vim.diagnostic.config({
			virtual_text = false,
		})

		local opts = { noremap = true, silent = true }
		vim.keymap.set("n", "<Leader>e", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
		vim.keymap.set("n", "<Leader>q", vim.diagnostic.setloclist, opts)

		-- Use an on_attach function to only map the following keys
		-- after the language server attaches to the current buffer
		local on_attach = function(client, bufnr)
			-- Mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", bufopts)
			vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", bufopts)
			vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", bufopts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
			vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", bufopts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
			vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, bufopts)
			vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, bufopts)
			-- vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, bufopts)
			vim.keymap.set("n", "<leader>i", function()
				vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
			end, bufopts)
		end

		-- Add additional capabilities supported by nvim-cmp
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local lspconfig = require("lspconfig")

		-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
		local servers = { "pylsp", "tsserver", "vimls", "dockerls", "lua_ls", "jsonls", "html", "cssls", "eslint" }
		for _, lsp in ipairs(servers) do
			lspconfig[lsp].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		require("lspconfig").postgres_lsp.setup({})

		-- rust-tools
		local rust_opts = {
			server = {
				on_attach = on_attach,
				capabilities = capabilities,
				settings = {
					["rust-analyzer"] = {
						checkOnSave = {
							command = "clippy",
						},
					},
				},
			},
		}
		require("rust-tools").setup(rust_opts)
	end,
}
