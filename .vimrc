" **********************************************************************
" File: .gvimrc             
" Version: 1.1
" Author: ye yan 
" Created: May-05-2010
" Last Change:  Wed Jul  1 14:39:15 ACST 2015

" **********************************************************************
" essential configurations

" set spell spelllang=en_us

" initialize pathogen and load modules
execute pathogen#infect()

" allow syntax highlighting
syntax on

" allow file type plugins
filetype plugin indent on

" use none compatible mode
set nocompatible

" by default ignorecase when search
" set ignorecase

" ********************************************************************** 
" gui configurations

if has("gui_running")
    " highlight searchings
    set hlsearch
    " incremental searchings
    set incsearch

    "On windows set font to courier
    if has("gui_win32")
        set guifont=Courier\ New:h14:b
        "set backupdir=~/.vimtemp/backup,~/vimbackups
        "set directory=~/.vimtemp/swap,.
    endif 
    " set default font
    "set guifont=monaco:h16
    
    "On Linux set font to monospace
    if has("gui_gtk")
        set guifont=DejaVu\ Sans\ Mono\ 14
        "set backupdir=~/.vim/temp/backup,.
        "set directory=~/.vim/temp/swap,.
    endif

    " use color scheme molokai, requires plugin
    colorscheme jellybeans

    " set vim size (based on lines and columns)
    set lines=30 columns=80
endif

" ********************************************************************** 
" Files, backups and undo

set nobackup
set nowb
set noswapfile

" ************************************************************************
" editing parameter configurations

" show the cursor position all the time
set ruler

" enable fold
set foldenable

" uncomment next line to show line numbers
"set number

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" 4 spaces for indenting
set shiftwidth=4

" 4 tab stops
set tabstop=4

" spaces instead of tabs, good when editing programing files
set expandtab

" always  set auto indenting on
set autoindent

" enable built-in spell checker
" set spell
" set spelllang=en_us

" allow modified buffer to be hidden
set hidden

" ignore case when searching
set ignorecase

" when a upper case if presented, use case sensitive
set smartcase

" Don't redraw while executing macros (good performance config)
set lazyredraw

" **********************************************************************
" Moving around, tabs, windows and buffers

" Treat long lines as break lines (useful when moving around in them)
" map j gj
" map k gk

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" **********************************************************************
" self defined functions

let g:editing_mode=0

function! ProgrammingModeToggle()
  if(has("gui_running"))
    if g:editing_mode == 0
      NERDTree
      set lines=999 columns=999
    else
      NERDTreeClose
      set lines=30 columns=80
    endif
  endif
  let g:editing_mode=(g:editing_mode+1)%2
endfunction

" ************************************************************************ 
" key mappings
nnoremap <leader>f :call ProgrammingModeToggle()<cr>

" shortcuts for copy and paste to system clipboard
vnoremap <C-insert> "+y
nnoremap <S-insert> "+p
inoremap <S-insert> <ESC>"+pa

" ************************************************************************ 
" abbreviations

" ************************************************************************
" Gradle && Groovy setup
au BufNewFile,BufRead *.gradle setf groovy
au BufNewFile,BufRead *.html.ftl setf html.ftl

" ************************************************************************
" Addon configurations

" Autoformat
" https://github.com/Chiel92/vim-autoformat
noremap <leader>b :Autoformat<CR><CR>

" tidy parameter for xhtml (the default parameter would produce a blank
" buffer if there is an unkown tag)
let g:formatprg_args_expr_xhtml = '"--input-xml 1 --indent 1 --indent-spaces ".&shiftwidth." --quiet 1 --indent-attributes 1 --vertical-space yes --tidy-mark no"'
let g:formatprg_args_expr_xml = '"-q -xml --show-errors 0 --show-warnings 0 --force-output --indent auto --indent-attributes 1 --indent-spaces ".&shiftwidth." --vertical-space yes --tidy-mark no -wrap ".&textwidth'
let g:formatprg_args_expr_cpp = '"--mode=c -N -xC120 --style=ansi -pcH".(&expandtab ? "s".&shiftwidth : "t")'

" TagBar
"  https://github.com/majutsushi/tagbar
nmap <F8> :TagbarToggle<CR>
nnoremap <F5> "=strftime("%F %T")<CR>P
nnoremap <F12> :setlocal spell! spelllang=en_us<CR>

function! FormatHaskell()
    execute "!" . "hindent" . " --style cramer " . bufname("%")
    edit!
endfunction

autocmd FileType haskell map <buffer> <localleader>b :call FormatHaskell()<cr><cr>
