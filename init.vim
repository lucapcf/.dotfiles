" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/plugged')

" Add the VimBeGood plugin
Plug 'ThePrimeagen/vim-be-good'

" Initialize plugin system
call plug#end()

" Basic settings for a better editing experience
set number           " Show line numbers
set relativenumber   " Show relative line numbers
set nocursorline     " Highlight the current line
set noswapfile       " Disable swap files
set nobackup         " Disable backup files
set undodir=~/.nvim/undodir
set undofile         " Enable persistent undo
set hidden           " Allow buffer switching without saving
set wrap             " Enable line wrapping
set scrolloff=8      " Keep 8 lines visible above/below the cursor
set sidescrolloff=8  " Keep 8 columns visible left/right of the cursor

" Improve window navigation
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-W>l

" Launch VimBeGood
command VimBeGood :VimBeGood

