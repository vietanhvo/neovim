return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local hooks = require "ibl.hooks"
    hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
      vim.api.nvim_set_hl(0, "IndentBlanklineScope", { fg = "#bdae93" })
    end)

    require("ibl").setup {
      scope = { highlight = { "IndentBlanklineScope" } }
    }
  end
}
