" SETS {{{
set title
set go=a
set mouse=a
set nohlsearch
set clipboard+=unnamedplus
set noshowmode
set nowrap
set noruler
set laststatus=0
set noshowcmd
set laststatus=2
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set encoding=utf-8
set number relativenumber
set splitbelow splitright
set hidden
set noswapfile
set nobackup
set undodir=~/.config/nvim/undodir
set undofile
set incsearch
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=number
set colorcolumn=80
set completeopt=menuone,noselect
set foldmethod=marker
" }}}
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

"}}}
" SETTINGS {{{
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
lua << EOF
    require('lualine').setup {
        options = {theme = 'palenight'}
        }

EOF
    set termguicolors
"    set t_Co=16
    let g:tokyonight_style = 'night' " available: night, storm
    let g:tokyonight_enable_italic = 1
"    set bg=dark
"    colorscheme gruvbox8
    colorscheme tokyonight
"}}}
" KEYBINDIGNS {{{
map Q gq
nnoremap c "_c
vnoremap . :normal .<CR>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
map <C-q> <C-w>q
nnoremap S :%s//g<Left><Left>
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
" Finder
nnoremap <leader>pf :Files<Cr>
command! -bang Dotfiles call fzf#vim#files('~/.config', <bang>0)
nnoremap <leader>pd :Dotfiles<Cr>
nnoremap <leader>pb :Buffers<Cr>
nnoremap <leader>ps :Ag<CR>
nnoremap <leader>ph :Helptags<CR>
" Code commands
nnoremap <leader>cg :CMakeGenerate<cr>
nnoremap <leader>cb :CMakeBuild<cr>
nnoremap <leader>cc :w! \| !compiler "<c-r>%"<CR>
nnoremap <leader>cf :<C-u>FormatCode<CR>
nnoremap <leader>co :SymbolsOutline<CR>
" DEBUGGER
nnoremap <leader>vr :VimspectorReset<CR>
nnoremap <leader>vw :VimspectorWatch
" GIT
nnoremap <leader>gl :diffget //3<CR>
nnoremap <leader>gh :diffget //2<CR>
nnoremap <leader>gs :G<CR>
" Misc
nnoremap <leader>mp :MarkdownPreviewToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <Leader><CR> :so ~/.config/nvim/init.vim<CR>
" }}}
" AUTOCOMMANDS AND FUNCTIONS {{{
    augroup MYGROUP
        autocmd!
        autocmd BufWritePost bm-files,bm-dirs !shortcuts
        autocmd FileType c,cpp,proto,javascript,arduino AutoFormatBuffer clang-format
        autocmd FileType python AutoFormatBuffer autopep8
    augroup END
"}}}
" LSP  {{{
lua << EOF
vim.lsp.set_log_level("debug")
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Mappings.
  local opts = { noremap=true, silent=false }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<leader>ff", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

local servers = { "clangd", "cmake", "bashls", "pyright" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup { on_attach = on_attach }
end

nvim_lsp.sumneko_lua.setup {
    cmd = {"/usr/bin/lua-language-server", "-E", "/usr/share/lua-language-server/main.lua"},
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
                path = vim.split(package.path, ';')
            },
            diagnostics = {
                globals = {
                    'vim',
                    'use',
                    'awesome',
                    'client',
                    'root'
                    }
            },
            workspace = {
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                    ['/usr/share/awesome/lib'] = true
                }
            }
        }
    },
    on_attach = on_attach;
}

EOF


" }}}
" COMPLETION {{{
lua << EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'always';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    ultisnips = true;
    treesitter = true;
  };
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    'documentation',
    'detail',
    'additionalTextEdits',
  }
}

require'lspconfig'.rust_analyzer.setup {
  capabilities = capabilities,
}

EOF

" NOTE: Order is important. You can't lazy loading lexima.vim.
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
" }}}
" TREESITTER {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
require'nvim-treesitter.configs'.setup {
  indent = {
    enable = true
  }
}
EOF
"}}}
