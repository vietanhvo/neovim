return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local lualine = require("lualine")
    local lazy_status = require("lazy.status")

    local colors = {
      cyan = '#008080',
      orange = '#FF8800',
    }
    lualine.setup({
      options = {
        icons_enabled = true,
        theme = auto,
        component_separators = { left = '', right = '' },
        disabled_filetypes = { 'dashboard' },
        section_separators = { left = '', right = '' },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        }
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename', {
          'lsp_progress',
          colors = {
            percentage      = colors.cyan,
            title           = colors.cyan,
            message         = colors.cyan,
            spinner         = colors.cyan,
            lsp_client_name = colors.orange,
            use             = true,
          },
          separators = {
            component = ' ',
            progress = ' | ',
            percentage = { pre = '', post = '%% ' },
            title = { pre = '', post = ': ' },
            lsp_client_name = { pre = '[', post = ']' },
            spinner = { pre = '', post = '' },
            message = { pre = '(', post = ')', commenced = 'In Progress', completed = 'Completed' },
          },
          display_components = { 'lsp_client_name', 'spinner', { 'title', 'percentage', 'message' } },
          timer = { progress_enddelay = 500, spinner = 1000, lsp_client_name_enddelay = 1000 },
          spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
        } },
        lualine_x = {
          {
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
          },
          { "encoding" },
          { "fileformat" },
          { "filetype" },
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
      },
      tabline = {
        lualine_a = { 'buffers' },
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = { 'tabs' }
      },
      winbar = {},
      inactive_winbar = {},
      extensions = { 'nvim-tree', 'nvim-dap-ui' }
    })
  end,
}
