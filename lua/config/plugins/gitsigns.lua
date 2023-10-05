return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local gitsign = require('gitsigns')

    gitsign.setup({
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
        ignore_whitespace = false,
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']g', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        map('n', '[g', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        map({ 'n', 'v' }, 'ghs', ':Gitsigns stage_hunk<CR>')
        map({ 'n', 'v' }, 'ghr', ':Gitsigns reset_hunk<CR>')
        map('n', 'ghS', gs.stage_buffer)
        map('n', 'ghu', gs.undo_stage_hunk)
        map('n', 'ghR', gs.reset_buffer)
        map('n', 'ghp', gs.preview_hunk)
        map('n', 'ghb', function() gs.blame_line { full = true } end)
      end,
    })
  end,
}
