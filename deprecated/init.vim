call plug#begin()
  " Plug 'sainnhe/gruvbox-material'
  " Plug 'nvim-lualine/lualine.nvim'
  " Plug 'williamboman/mason.nvim'
  " Plug 'williamboman/mason-lspconfig.nvim'
  " Plug 'neovim/nvim-lspconfig'
  " Plug 'hrsh7th/nvim-cmp'
  " Plug 'hrsh7th/cmp-nvim-lsp'
  " Plug 'hrsh7th/cmp-nvim-lua'
  " Plug 'saadparwaiz1/cmp_luasnip'
  " Plug 'L3MON4D3/LuaSnip'
  " Plug 'hrsh7th/cmp-buffer'
  " Plug 'hrsh7th/cmp-path'
  " Plug 'Saecki/crates.nvim'
  " Plug 'glepnir/dashboard-nvim'
  " Plug 'kyazdani42/nvim-web-devicons'
  " Plug 'kyazdani42/nvim-tree.lua'
  " Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  " Plug 'nvim-lua/plenary.nvim'
  " Plug 'nvim-lua/popup.nvim'
  " Plug 'nvim-telescope/telescope.nvim'
  " Plug 'nvim-telescope/telescope-file-browser.nvim'
  " Plug 'nvim-telescope/telescope-ui-select.nvim'
  " Plug 'numToStr/Comment.nvim'
  " Plug 'lewis6991/gitsigns.nvim'
  " Plug 'sindrets/diffview.nvim'
  " Plug 'kylechui/nvim-surround'
  " Plug 'mg979/vim-visual-multi', {'branch': 'test'}
  " Plug 'norcalli/nvim-colorizer.lua'
  " Plug 'lukas-reineke/indent-blankline.nvim'
  " Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'HiPhish/rainbow-delimiters.nvim'
  " Plug 'windwp/nvim-ts-autotag'
  " Plug 'windwp/nvim-autopairs'
  " Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  " Plug 'simrat39/rust-tools.nvim'
  Plug 'akinsho/flutter-tools.nvim'
  " Plug 'mfussenegger/nvim-dap'
  " Plug 'rcarriga/nvim-dap-ui'
  " Plug 'RRethy/vim-illuminate'
  " Plug 'm-demare/hlargs.nvim'
  " Plug 'rmagatti/goto-preview'
  " Plug 'onsails/lspkind.nvim'
  " Plug 'zbirenbaum/copilot.lua'
  " Plug 'zbirenbaum/copilot-cmp'
  " Plug 'arkav/lualine-lsp-progress'
  " Plug 'mfussenegger/nvim-jdtls'
call plug#end()

let g:python3_host_prog='/usr/bin/python3'
" ColorScheme syntax enable
autocmd ColorScheme * highlight! link SignColumn LineNr
if has('termguicolors')
    set termguicolors
endif
" For dark version.
set background=dark
let g:gruvbox_material_background = 'hard'
let g:gruvbox_material_diagnostic_virtual_text = 'colored'
let g:gruvbox_material_sign_column_background = 'none'
let g:gruvbox_material_palette = 'original'
let g:gruvbox_material_colors_override={
  \ 'bg_dim':           ['#121314',   '232'],
  \ 'bg0':              ['#1b1c1d',   '234'],
  \ 'bg1':              ['#262626',   '235'],
  \ 'bg2':              ['#262626',   '235'],
  \ 'bg3':              ['#373534',   '237'],
  \ 'bg4':              ['#373534',   '237'],
  \ 'bg5':              ['#4f4c49',   '239'],
  \ 'bg_statusline1':   ['#262626',   '235'],
  \ 'bg_statusline2':   ['#2f2d2b',   '235'],
  \ 'bg_statusline3':   ['#4f4c49',   '239'],
  \ 'bg_diff_green':    ['#2d321b',   '22'],
  \ 'bg_visual_green':  ['#2f3729',   '22'],
  \ 'bg_diff_red':      ['#351f1e',   '52'],
  \ 'bg_visual_red':    ['#3f2c2b',   '52'],
  \ 'bg_diff_blue':     ['#102c32',   '17'],
  \ 'bg_visual_blue':   ['#273131',   '17'],
  \ 'bg_visual_yellow': ['#443e2a',   '94'],
  \ 'bg_current_word':  ['#2f2d2b',   '236']}

colorscheme gruvbox-material

" General Setup
let mapleader = " "
set backspace=2
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler
set showcmd
set incsearch
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands
set autoread

set autoindent
set smartindent

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Numbers ruler
set relativenumber
set number
set numberwidth=5
hi CursorLineNr guifg=Yellow guibg=none
set cursorline

" Use one space, not two, after punctuation.
set nojoinspaces

" Open split window position
set splitbelow
set splitright

" Copy to clipboard
set clipboard+=unnamedplus

filetype plugin indent on

" Split window
nnoremap <Leader>v :vsplit<CR>
nnoremap <Leader>s :split<CR>

" telescope
noremap <leader>p <cmd>Telescope find_files<cr>
noremap <leader>h <cmd>Telescope oldfiles<cr>
noremap <leader>m <cmd>Telescope marks<cr>
noremap <leader>w <cmd>Telescope live_grep<cr>
noremap <leader>c <cmd>Telescope colorscheme<cr>
noremap <leader>b <cmd>Telescope file_browser<cr>

" Multi cursor
let g:VM_mouse_mappings = 1

" Move between windows
map <M-h> <C-W>h
map <M-l> <C-W>l
map <M-j> <C-W>j
map <M-k> <C-W>k

" Resize windows by arrow keys
map <silent> <Right> <C-w><
map <silent> <Down> <C-W>-
map <silent> <Up> <C-W>+
map <silent> <Left> <C-w>>

" Visual background
hi Visual  guifg=none guibg=#504945 gui=none

" Highlight for nvim tree
hi NvimTreeSpecialFile guifg=#ff7800

" Go to preview
nnoremap gd <cmd>lua require('goto-preview').goto_preview_definition()<CR>
nnoremap gt <cmd>lua require('goto-preview').goto_preview_type_definition()<CR>
nnoremap gi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>
nnoremap gr <cmd>lua require('goto-preview').goto_preview_references()<CR>
nnoremap gq <cmd>lua require('goto-preview').close_all_win({ skip_curr_window = true })<CR>

" nvim-dap
nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> m <Cmd>lua require'dap'.toggle_breakpoint()<CR>
