return {
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      local g = vim.g
      g.gruvbox_material_background = 'hard'
      g.gruvbox_material_diagnostic_virtual_text = 'colored'
      g.gruvbox_material_sign_column_background = 'none'
      g.gruvbox_material_palette = 'mix'
      g.gruvbox_material_colors_override = {
        bg_dim = { '#121314', '232' },
        bg0 = { '#1b1c1d', '234' },
        bg1 = { '#262626', '235' },
        bg2 = { '#262626', '235' },
        bg3 = { '#373534', '237' },
        bg4 = { '#373534', '237' },
        bg5 = { '#4f4c49', '239' },
        bg_statusline1 = { '#262626', '235' },
        bg_statusline2 = { '#2f2d2b', '235' },
        bg_statusline3 = { '#4f4c49', '239' },
        bg_diff_green = { '#2d321b', '22' },
        bg_visual_green = { '#2f3729', '22' },
        bg_diff_red = { '#351f1e', '52' },
        bg_visual_red = { '#3f2c2b', '52' },
        bg_diff_blue = { '#102c32', '17' },
        bg_visual_blue = { '#273131', '17' },
        bg_visual_yellow = { '#443e2a', '94' },
        bg_current_word = { '#2f2d2b', '236' },
      }
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  }
}
