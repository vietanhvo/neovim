-- telescope
require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')

require('telescope').setup {
    extensions = {
        ['ui-select'] = {
            require('telescope.themes').get_dropdown {}
        },
        media_files = {
            find_cmd = "rg"
        }
    }
}
require('telescope').load_extension('ui-select')
