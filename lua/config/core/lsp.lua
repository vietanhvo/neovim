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
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end)
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end)
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
	vim.keymap.set("n", "<leader>i", function()
		vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
	end, bufopts)
end

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

-- LSP server configurations
local server_configs = {
	-- Basic servers with default config
	basic_servers = {
		"ts_ls",
		"vimls",
		"dockerls",
		"jsonls",
		"html",
		"cssls",
		"jdtls",
		"postgres_lsp",
	},
	-- Servers with custom settings
	pyright = {
		on_attach = on_attach,
		settings = {
			pyright = {
				-- Using Ruff's import organizer
				disableOrganizeImports = true,
			},
			python = {
				analysis = {
					ignore = { "*" },
				},
			},
		},
	},
	eslint = {
		on_attach = on_attach,
		settings = {
			experimental = {
				useFlatConfig = true,
			},
			validate = "probe",
		},
	},
	lua_ls = {
		on_attach = on_attach,
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
			},
		},
	},
}

-- Helper function to setup and enable server
local function setup_server(server_name, config)
	vim.lsp.config(server_name, config or { on_attach = on_attach })
	vim.lsp.enable(server_name)
end

-- Setup basic servers
for _, server in ipairs(server_configs.basic_servers) do
	setup_server(server)
end

-- Setup servers with custom configurations
setup_server("pyright", server_configs.pyright)
setup_server("eslint", server_configs.eslint)
setup_server("lua_ls", server_configs.lua_ls)
