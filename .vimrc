set nocompatible

" Highlight all search matches
set hlsearch
" Always display status line
set laststatus=2
" Disable autoindent with Ctrl-p for pasting (insert mode only)
set pastetoggle=<C-P>
" unset the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>
" Show matching brackets.
set showmatch
" Highlight syntax
syntax on

" maps ^a to go to beginning of the line, like in terminal
map <C-a> 0
" maps ^e to go to the end of the line, like in terminal
map <C-e> $

" Remember location in file
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Enable indentation preferences and whitespace highlighting (mostly)
inoremap # X<c-h>#
set tabstop=4
set shiftwidth=4
set smartindent
set expandtab
set softtabstop=4
set autoindent
set number
set clipboard=unnamed
set colorcolumn=80
" Set mouse capture as default
set mouse=a

" set backspace mapping to fix backspace problems in insert mode on mac osx
set backspace=indent,eol,start

" set color highlight preferences
highlight BadWhitespace ctermbg=red ctermfg=red
" bad whitespace matching set to ANY tab
match BadWhitespace /\t/
" tell vim-better-whitespace plugin to strip whitespace on save
let strip_whitespace_on_save = 1

" Set indentation to 2 spaces for some file types:
au FileType ruby,scala,yaml setl shiftwidth=2 softtabstop=2 tabstop=2

" do not expand tabs in go & make files
au FileType go,make setl noexpandtab shiftwidth=4 softtabstop=4 tabstop=4
" in make files, highlight leading spaces as BadWhiteSpace
au FileType make match BadWhiteSpace /^ \+/
" in go files, do not highlight BadWhiteSpace (vim-go deals w/ this)
au FileType go match BadWhiteSpace //

" .sls salt state files are yaml
au BufRead,BufNewFile *.sls set filetype=yaml
" Vagrantfiles are ruby
au BufRead,BufNewFile Vagrantfile* set filetype=ruby
