-- notify
vim.notify = require("notify")

-- navigate with hop
require 'hop'.setup()

-- go to definition in preview window
require('goto-preview').setup {
    height = 20,
}

-- dap
require("dapui").setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

-- surround
require('nvim-surround').setup {}

-- comment
require('Comment').setup {
    pre_hook = function(ctx)
        local U = require 'Comment.utils'

        local location = nil
        if ctx.ctype == U.ctype.block then
            location = require('ts_context_commentstring.utils').get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
        end

        return require('ts_context_commentstring.internal').calculate_commentstring {
            key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
            location = location,
        }
    end,
}
require('todo-comments').setup {}

-- Sign for Diagnostics
local signs = {
    Error = "",
    Warn = "",
    Hint = "",
    Infor = ""
}

for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- treesitter
require('nvim-treesitter.configs').setup {
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true
    },
    rainbow = {
        enable = true,
        extended_mode = true,
    },
    autotag = {
        enable = true,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    }
}

require('nvim-autopairs').setup {
    check_ts = true,
}


require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
    filetype_exclude = { "dashboard" },
}
require 'colorizer'.setup()
require('neoscroll').setup({
    mappings = { '<C-u>', '<C-d>', '', '',
        '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
})

require('hlargs').setup()

-- crates
require('crates').setup()
local crates = require('crates')
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>cv', crates.show_versions_popup, opts)
vim.keymap.set('n', '<leader>cf', crates.show_features_popup, opts)
vim.keymap.set('n', '<leader>cd', crates.show_dependencies_popup, opts)

-- Dashboard
local db = require('dashboard')
db.setup({
    theme = 'hyper',
    config = {
        week_header = {
            enable = true,
        },
        packages = { enable = false },
    },
})
