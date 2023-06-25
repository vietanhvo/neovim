-- Copilot cmp
require("copilot_cmp").setup()

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local source_mapping = {
    buffer = "[Buffer]",
    nvim_lsp = "[LSP]",
    nvim_lua = "[Lua]",
    cmp_tabnine = "[TN]",
    path = "[Path]",
    copilot = "[Copilot]"
}
local lspkind = require('lspkind')

local compare = require('cmp.config.compare')
local cmp = require 'cmp'
local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-k>'] = cmp.mapping.scroll_docs(-4),
        ['<C-j>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sorting = {
        priority_weight = 2,
        comparators = {
            --[[ require('cmp_tabnine.compare'), ]]
            require('copilot_cmp.comparators').prioritize,
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.kind,
            compare.sort_text,
            compare.length,
            compare.order,
        },
    },
    sources = {
        { name = 'path' },
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'nvim_lua' },
        { name = 'luasnip' },
        { name = 'nvim_lsp_signature_help' },
        { name = 'crates' },
        { name = 'cmp_tabnine' },
        { name = 'copilot' }
    },
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            before = function(entry, vim_item)
                vim_item.kind = lspkind.presets.default[vim_item.kind]

                local menu = source_mapping[entry.source.name]
                if entry.source.name == "cmp_tabnine" then
                    if entry.completion_item.data ~= nil and entry.completion_item.data.detail ~= nil then
                        menu = entry.completion_item.data.detail .. " " .. menu
                    end
                    vim_item.kind = ""
                    vim_item.kind_hl_group = "CmpItemKindTabnine"
                end
                if entry.source.name == "copilot" then
                    vim_item.kind = ""
                    vim_item.kind_hl_group = "CmpItemKindCopilot"
                end

                vim_item.menu = menu

                return vim_item
            end,
        }),
    },
}

vim.api.nvim_set_hl(0, "CmpItemKindTabnine", { fg = "#9967f5" })
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
