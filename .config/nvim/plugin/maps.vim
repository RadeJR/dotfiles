
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
" NOTE: Order is important. You can't lazy loading lexima.vim.
let g:lexima_no_default_rules = v:true
call lexima#set_default_rules()
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm(lexima#expand('<LT>CR>', 'i'))
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })
