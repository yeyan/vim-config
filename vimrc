" **********************************************************************
" File: .gvimrc             
" Version: 1.1
" Author: ye yan 
" Created: May-05-2010
" Last Change: 2017-09-25 13:00:07 

" **********************************************************************
" Basic configurations

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
" GUI configurations

if has("gui_running")
    " highlight searchings
    set hlsearch
    " incremental searchings
    set incsearch

    "On windows set font to courier
    if has("gui_win32")
        set guifont=Courier\ New:h14:b
    endif 
    " set default font
    "set guifont=monaco:h16
    
    "On Linux set font to monospace
    if has("gui_gtk")
        set guifont=DejaVu\ Sans\ Mono\ 14
    endif

    "On OSX set the font to Monaco
    if has("gui_macvim")
        set guifont=Monaco:h16
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
" Editing parameter configurations

" show the cursor position all the time
set ruler

" enable fold
set foldenable

" uncomment next line to show line numbers
set number

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
" PS (make it hard for you to go to certain point of a long line)
" map j gj
" map k gk

" Smart way to move between windows
" Not so sure I want this
" map <C-j> <C-W>j
" map <C-k> <C-W>k
" map <C-h> <C-W>h
" map <C-l> <C-W>l

" **********************************************************************
" Programming language or add-on specific configuration

" Programming mode
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

nnoremap <leader>f :call ProgrammingModeToggle()<cr>

" Shortcuts for copy and paste to system clipboard
vnoremap <C-insert> "+y
nnoremap <S-insert> "+p
inoremap <S-insert> <ESC>"+pa

" Gradle && Groovy setup

au BufNewFile,BufRead *.gradle setf groovy
au BufNewFile,BufRead *.html.ftl setf html.ftl

" Autoformat
" https://github.com/Chiel92/vim-autoformat

noremap <leader>b :Autoformat<CR><CR>

" tidy parameter for xhtml (the default parameter would produce a blank
" buffer if there is an unkown tag)
let g:formatprg_args_expr_xhtml = '"--input-xml 1 --indent 1 --indent-spaces ".&shiftwidth." --quiet 1 --indent-attributes 1 --vertical-space yes --tidy-mark no"'
let g:formatprg_args_expr_xml = '"-q -xml --show-errors 0 --show-warnings 0 --force-output --indent auto --indent-attributes 1 --indent-spaces ".&shiftwidth." --vertical-space yes --tidy-mark no -wrap ".&textwidth'
let g:formatprg_args_expr_cpp = '"--mode=c -N -xC120 --style=ansi -pcH".(&expandtab ? "s".&shiftwidth : "t")'

" Haskell
function! FormatHaskell()
    execute "!" . "hindent" . " --style cramer " . bufname("%")
    edit!
endfunction

autocmd FileType haskell map <buffer> <localleader>b :call FormatHaskell()<cr><cr>

" TagBar
" https://github.com/majutsushi/tagbar

nmap <F8> :TagbarToggle<CR>

" Time stamp
nnoremap <F5> "=strftime("%F %T")<CR>P

" Enable spell checking
nnoremap <F12> :setlocal spell! spelllang=en_us<CR>

" Syntastic
" https://github.com/vim-syntastic/syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_mode_map = {
    \ "mode": "active",
    \ "passive_filetypes": ["java", "html"] }

" Live down 
" github: https://github.com/shime/vim-livedown

nmap <C-p> :LivedownToggle<CR>

" Octave setup
autocmd BufRead,BufNewFile *.m set filetype=octave

" VimShell
" https://github.com/Shougo/vimshell.vim
let g:vimshell_editor_command="/usr/local/bin/mvim"