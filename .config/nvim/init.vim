" PLUGINS {{{
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-commentary'

Plug 'hoob3rt/lualine.nvim'
Plug 'ryanoasis/vim-devicons'
Plug 'ghifarit53/tokyonight-vim'
Plug 'lifepillar/vim-gruvbox8'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'cdelledonne/vim-cmake'
Plug 'vimwiki/vimwiki'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'kana/vim-operator-user'
Plug 'puremourning/vimspector', {
  \ 'do': 'python3 install_gadget.py --enable-cpp'
  \ }
Plug 'mbbill/undotree'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'simrat39/symbols-outline.nvim'
Plug 'cohama/lexima.vim'

Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

call plug#end()
call glaive#Install()
" }}}
    let mapleader =" "
    let g:fzf_layout = { 'down': '40%' }
    let g:cmake_link_compile_commands = 1
    let g:vimspector_enable_mappings = 'HUMAN'
    let g:vimwiki_markdown_link_ext = 1
    let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
    filetype plugin indent on
    filetype plugin on
    syntax on

    let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
    let g:vimwiki_list = [{'path': '~/OneDrive/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]

    set termguicolors
"    set t_Co=16
    let g:tokyonight_style = 'night' " available: night, storm
    let g:tokyonight_enable_italic = 1
"    set bg=dark
"    colorscheme gruvbox8
    colorscheme tokyonight

    augroup MYGROUP
        autocmd!
        autocmd BufWritePost bm-files,bm-dirs !shortcuts
        autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
        autocmd FileType python AutoFormatBuffer autopep8
    augroup END
lua << EOF
    require('lualine').setup {
        options = {theme = 'palenight'}
        }
EOF
