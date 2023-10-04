return {
  "rmagatti/goto-preview",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local preview = require('goto-preview')
    -- set keymaps
    local keymap = vim.keymap
    keymap.set('n', 'gd', preview.goto_preview_definition, { noremap = true })
    keymap.set('n', 'gt', preview.goto_preview_type_definition, { noremap = true })
    keymap.set('n', 'gi', preview.goto_preview_implementation, { noremap = true })
    keymap.set('n', 'gr', preview.goto_preview_references, { noremap = true })
    keymap.set('n', 'gq', preview.close_all_win, { noremap = true })

    preview.setup()
  end
}
