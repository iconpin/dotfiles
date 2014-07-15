execute pathogen#infect()

filetype plugin indent on
syntax on

set number
set norelativenumber
set modeline
set ruler
set scrolloff=5

set expandtab
set shiftwidth=2
set tabstop=2
set softtabstop=2

colorscheme solarized
set background=dark

let g:lightline = {
      \ 'colorscheme': 'solarized'
      \ }

set laststatus=2

let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

autocmd FileType ruby nmap <buffer> <C-m> <Plug>(xmpfilter-mark)
autocmd FileType ruby nmap <buffer> <C-r> <Plug>(xmpfilter-run)

nnoremap <C-h> :bp<cr>
nnoremap <C-l> :bn<cr>

nnoremap <C-j> 10j
nnoremap <C-k> 10k

nnoremap <C-f> ==

nmap sj :SplitjoinSplit<cr>
nmap sk :SplitjoinJoin<cr>

set tags+=./tags

set completefunc=emoji#complete

nmap semoji :%s/:\([^:]\+\):/\=emoji#for(submatch(1), submatch(0))/g<cr>
