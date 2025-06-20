return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"saghen/blink.cmp",
		-- "hrsh7th/cmp-nvim-lsp",
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
		local on_attach = function(_, bufnr)
			-- Mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			local bufopts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", bufopts)
			vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", bufopts)
			vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", bufopts)
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
			vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", bufopts)
			vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
			vim.keymap.set({ "n", "i" }, "<C-k>", vim.lsp.buf.signature_help, bufopts)
			vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, bufopts)
			vim.keymap.set("n", "<Leader>a", vim.lsp.buf.code_action, bufopts)
			-- vim.keymap.set('n', '<Leader>f', vim.lsp.buf.format, bufopts)
			vim.keymap.set("n", "<leader>i", function()
				vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
			end, bufopts)
		end

		-- Add additional capabilities supported by nvim-cmp
		-- local capabilities = vim.lsp.protocol.make_client_capabilities()
		-- capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		vim.diagnostic.config({
			float = {
				source = false,
				border = "single",
				header = false,
				format = function(diagnostic)
					return string.format("%s: %s ", diagnostic.source or "", diagnostic.message)
				end,
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,

			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "",
				},
				numhl = {
					[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
					[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
					[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
					[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
				},
			},
		})

		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
			border = "single",
		})

		vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
			border = "single",
		})

		require("lspconfig.ui.windows").default_options = {
			border = "single",
		}

		-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
		local servers = { "pylsp", "ts_ls", "vimls", "dockerls", "lua_ls", "jsonls", "html", "cssls", "jdtls" }
		for _, lsp in ipairs(servers) do
			vim.lsp.config(lsp, {
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		vim.lsp.config("eslint", {
			on_attach = on_attach,
			capabilities = capabilities,
			settings = {
				experimental = {
					useFlatConfig = true,
				},
				validate = "probe",
			},
		})

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		vim.lsp.config("postgres_lsp", {})

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
