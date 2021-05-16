" VimPlug {{{
if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'tpope/vim-surround'
Plug 'jreybert/vimagit'
Plug 'vimwiki/vimwiki'
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color'
Plug 'ghifarit53/tokyonight-vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'cdelledonne/vim-cmake'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'voldikss/vim-floaterm'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'honza/vim-snippets'
Plug 'jackguo380/vim-lsp-cxx-highlight'
Plug 'vim-syntastic/syntastic'
Plug 'rhysd/vim-clang-format'
Plug 'kana/vim-operator-user'
Plug 'puremourning/vimspector', {
  \ 'do': 'python3 install_gadget.py --enable-cpp'
  \ }
call plug#end()
" }}}

" Settings
    let mapleader =" "
    set title
    set bg=light
    set go=a
    set mouse=a
    set nohlsearch
    set clipboard+=unnamedplus
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
    set termguicolors
    set nocompatible
    set laststatus=2
    filetype plugin indent on
    filetype plugin on
    set tabstop=4
    set shiftwidth=4
    set expandtab
    syntax on
    set encoding=utf-8
    set number relativenumber
    let g:tokyonight_style = 'night' " available: night, storm
    let g:tokyonight_enable_italic = 1
    colorscheme tokyonight
    set splitbelow splitright
    let g:fzf_layout = { 'down': '40%' }
    let g:cmake_link_compile_commands = 1
    let g:syntastic_cpp_checkers = ['cpplint']
    let g:syntastic_c_checkers = ['cpplint']
    let g:syntastic_cpp_cpplint_exec = 'cpplint'
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 0
    let g:clang_format#auto_format = 1
    let g:vimspector_enable_mappings = 'HUMAN'

" Mappings
    nnoremap c "_c
    " Perform dot commands over visual blocks:
    vnoremap . :normal .<CR>
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l
    map <C-q> <C-w>q
    map Q gq
    nnoremap S :%s//g<Left><Left>
    " Compiler
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
    " Fzf
    nnoremap <C-p> :Files<Cr>
    nnoremap <C-m> :Buffers<Cr>
    nmap <leader>mg :Magit<CR>
    nmap <leader>cg :CMakeGenerate<cr>
    nmap <leader>cb :CMakeBuild<cr>
    nmap <leader>cc :w! \| !compiler "<c-r>%"<CR>
    let g:floaterm_keymap_new = '<Leader>tf'
    let g:floaterm_keymap_toggle = '<Leader>tt'
    nmap <leader>mp :MarkdownPreviewToggle<CR>
    nnoremap <leader>cf :<C-u>ClangFormat<CR>
    vnoremap <leader>f :<C-u>ClangFormat<CR>
    nnoremap <leader>ch :LspCxxHighlight<CR>
    command! -nargs=+ Vfb call vimspector#AddFunctionBreakpoint(<f-args>)
    nnoremap <leader>gd :call vimspector#Launch()<cr>
    nnoremap <leader>gc :call vimspector#Continue()<cr>
    nnoremap <leader>gs :call vimspector#Stop()<cr>
    nnoremap <leader>gR :call vimspector#Restart()<cr>
    nnoremap <leader>gp :call vimspector#Pause()<cr>
    nnoremap <leader>gb :call vimspector#ToggleBreakpoint()<cr>
    nnoremap <leader>gB :call vimspector#ToggleConditionalBreakpoint()<cr>
    nnoremap <leader>gn :call vimspector#StepOver()<cr>
    nnoremap <leader>gi :call vimspector#StepInto()<cr>
    nnoremap <leader>go :call vimspector#StepOut()<cr>
    nnoremap <leader>gr :call vimspector#RunToCursor()<cr>


" Autocommands and functions
    " Runs a script that cleans out tex build files whenever I close out of a .tex file.
    autocmd VimLeave *.tex !texclear %
    " Ensure files are read as what I want:
    let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
    let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
    autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
    autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
    autocmd BufRead,BufNewFile *.tex set filetype=tex
    " Disables automatic commenting on newline:
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
    " Marker based folding
    autocmd FileType vim,cpp setlocal foldmethod=marker
    " When shortcut files are updated, renew bash and ranger cnfigs with new material:
    autocmd BufWritePost bm-files,bm-dirs !shortcuts
    " Run xrdb whenever Xdefaults or Xresources are updated.
    autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
    autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Coc Config {{{
    set hidden
    set nobackup
    set nowritebackup
    " Give more space for displaying messages.
    set cmdheight=2
    " Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
    " delays and poor user experience.
    set updatetime=300
    " Don't pass messages to |ins-completion-menu|.
    set shortmess+=c
    if has("nvim-0.5.0") || has("patch-8.1.1564")
      " Recently vim can merge signcolumn and number column into one
      set signcolumn=number
    else
      set signcolumn=yes
    endif
    " Use tab for trigger completion with characters ahead and navigate.
    inoremap <silent><expr> <TAB>
          \ pumvisible() ? "\<C-n>" :
          \ <SID>check_back_space() ? "\<TAB>" :
          \ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    " Use <c-space> to trigger completion.
    if has('nvim')
      inoremap <silent><expr> <c-space> coc#refresh()
    else
      inoremap <silent><expr> <c-@> coc#refresh()
    endif
    " Make <CR> auto-select the first completion item and notify coc.nvim to
    " format on enter, <cr> could be remapped by other vim plugin
    inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                                  \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
    " Use `[g` and `]g` to navigate diagnostics
    " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
    nmap <silent> [g <Plug>(coc-diagnostic-prev)
    nmap <silent> ]g <Plug>(coc-diagnostic-next)
    " GoTo code navigation.
    nmap <silent> gd <Plug>(coc-definition)
    nmap <silent> gy <Plug>(coc-type-definition)
    nmap <silent> gi <Plug>(coc-implementation)
    nmap <silent> gr <Plug>(coc-references)
    " Use K to show documentation in preview window.
    nnoremap <silent> K :call <SID>show_documentation()<CR>
    function! s:show_documentation()
      if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
      elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
      else
        execute '!' . &keywordprg . " " . expand('<cword>')
      endif
    endfunction
    " Highlight the symbol and its references when holding the cursor.
    autocmd CursorHold * silent call CocActionAsync('highlight')
    " Symbol renaming.
    nmap <leader>rn <Plug>(coc-rename)
    " Formatting selected code.
    " xmap <leader>f  <Plug>(coc-format-selected)
    " nmap <leader>f  <Plug>(coc-format-selected)
    augroup mygroup
      autocmd!
      " Setup formatexpr specified filetype(s).
      autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
      " Update signature help on jump placeholder.
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup end
    " Applying codeAction to the selected region.
    " Example: `<leader>aap` for current paragraph
    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)
    " Remap keys for applying codeAction to the current buffer.
    nmap <leader>ac  <Plug>(coc-codeaction)
    " Apply AutoFix to problem on the current line.
    nmap <leader>qf  <Plug>(coc-fix-current)
    " Map function and class text objects
    " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
    xmap if <Plug>(coc-funcobj-i)
    omap if <Plug>(coc-funcobj-i)
    xmap af <Plug>(coc-funcobj-a)
    omap af <Plug>(coc-funcobj-a)
    xmap ic <Plug>(coc-classobj-i)
    omap ic <Plug>(coc-classobj-i)
    xmap ac <Plug>(coc-classobj-a)
    omap ac <Plug>(coc-classobj-a)
    " Remap <C-f> and <C-b> for scroll float windows/popups.
    if has('nvim-0.4.0') || has('patch-8.2.0750')
      nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
      inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
      inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
      vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
      vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    endif
    " Use CTRL-S for selections ranges.
    " Requires 'textDocument/selectionRange' support of language server.
    nmap <silent> <C-s> <Plug>(coc-range-select)
    xmap <silent> <C-s> <Plug>(coc-range-select)
    " Add `:Format` command to format current buffer.
    command! -nargs=0 Format :call CocAction('format')
    " Add `:Fold` command to fold current buffer.
    command! -nargs=? Fold :call     CocAction('fold', <f-args>)
    " Add `:OR` command for organize imports of the current buffer.
    command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
    " Add (Neo)Vim's native statusline support.
    " NOTE: Please see `:h coc-status` for integrations with external plugins that
    " provide custom statusline: lightline.vim, vim-airline.
    set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
    " Mappings for CoCList
    " Show all diagnostics.
    nnoremap <silent><nowait> <leader>la  :<C-u>CocList diagnostics<cr>
    " Manage extensions.
    nnoremap <silent><nowait> <leader>le  :<C-u>CocList extensions<cr>
    " Show commands.
    nnoremap <silent><nowait> <leader>lc  :<C-u>CocList commands<cr>
    " Find symbol of current document.
    nnoremap <silent><nowait> <leader>lo  :<C-u>CocList outline<cr>
    " Search workspace symbols.
    nnoremap <silent><nowait> <leader>ls  :<C-u>CocList -I symbols<cr>
    " List snippets available
    nnoremap <silent><nowait> <leader>ll  :<C-u>CocList snippets<cr>
    " Do default action for next item.
    nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
    " Do default action for previous item.
    nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
    " Resume latest coc list.
    nnoremap <silent><nowait> <leader>lr  :<C-u>CocListResume<CR>
    " }}}
