return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "simrat39/rust-tools.nvim"
  },
  config = function()
    ---@diagnostic disable: undefined-global
    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    vim.diagnostic.config({
      virtual_text = false,
    })

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
      -- Mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      local bufopts = { noremap = true, silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
      vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
      vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)
    end

    -- Add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    local lspconfig = require('lspconfig')

    -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
    local servers = { 'pyright', 'tsserver', 'vimls', 'dockerls', 'lua_ls', 'jsonls', 'html', 'cssls' }
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
      }
    end

    -- rust-tools
    local rust_opts = {
      server = {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = {
              command = "clippy"
            },
          }
        }
      },
    }
    require('rust-tools').setup(rust_opts)
  end,
}
