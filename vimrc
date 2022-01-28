" **********************************************************************
" File: .gvimrc
" Version: 1.2
" Author: Ye Yan
" Created: May-05-2010
" Last-Updated: 2019-04-12 09:10:27
"
" Change History:
"   2018-08-21 12:21:56
"       -- use Plug instead of parthenon for plugin managment
"       -- use neovim/neomake for make and lint
"   2018-11-16 14:21:48
"       -- remove unused plugin "dodgelang"
"       -- correct key binding
"       -- clean up legacy section

" **********************************************************************
" Basic configurations

" set spell spelllang=en_us

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

function! s:ConfigGuiVim()

    " highlight searchings
    set hlsearch

    " incremental searchings
    set incsearch

    "On windows set font to courier
    if has("gui_win32")
        set guifont=Courier\ New:h14:b
    endif

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

    " Custom layout
    let g:editing_mode=0

    function! ProgrammingModeToggle()
        if g:editing_mode == 0
            NERDTree
            set lines=999 columns=999
        else
            NERDTreeClose
            set lines=30 columns=80
        endif
        let g:editing_mode=(g:editing_mode+1)%2
    endfunction

    let NERDTreeIgnore=['\.pyc$[[file]]']

    " Key bindings
    tnoremap <ESC> <C-W><S-N>

    tnoremap <C-j> <C-W>j
    tnoremap <C-k> <C-W>k
    tnoremap <C-h> <C-W>h
    tnoremap <C-l> <C-W>l

    map <C-j> <C-W>j
    map <C-k> <C-W>k
    map <C-h> <C-W>h
    map <C-l> <C-W>l

    " Programming mode
    nnoremap <leader>f :call ProgrammingModeToggle()<cr>

endfunction

if has("gui_running")
    autocmd VIMEnter * :call s:ConfigGuiVim()
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

" **********************************************************************
" load plugins

call plug#begin()

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'Vimjas/vim-python-pep8-indent', { 'for': 'python' }

" Noemake for async linting and make
Plug 'neomake/neomake'

" Python support
Plug 'vim-python/python-syntax'

" Autoformat
Plug 'Chiel92/vim-autoformat'

" Markdown preview with mathemtical formula support
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

" Vue support
Plug 'posva/vim-vue'

" Julia language support
Plug 'JuliaEditorSupport/julia-vim'

" Ack support
Plug 'mileszs/ack.vim'

" Cassandra CQL support
Plug 'elubow/cql-vim'

" Octave
Plug 'jvirtanen/vim-octave'

" Tabular
" Plug 'godlygeek/tabular'

" Ale
Plug 'dense-analysis/ale'

" Scala
Plug 'derekwyatt/vim-scala'

" Ack
Plug 'mileszs/ack.vim'

" Jellybean theme
Plug 'nanotech/jellybeans.vim'

call plug#end()

" **********************************************************************
" Plugins configuration

" Only do make when writing the buffer
if exists('neomake')
    call neomake#configure#automake('w')
endif

" Autoformat
" tidy parameter for xhtml (the default parameter would produce a blank buffer if there is an unkown tag)
let g:formatprg_args_expr_xhtml = '"--input-xml 1 --indent 1 --indent-spaces ".&shiftwidth." --quiet 1 --indent-attributes 1 --vertical-space yes --tidy-mark no"'
let g:formatprg_args_expr_xml = '"-q -xml --show-errors 0 --show-warnings 0 --force-output --indent auto --indent-attributes 1 --indent-spaces ".&shiftwidth." --vertical-space yes --tidy-mark no -wrap ".&textwidth'
let g:formatprg_args_expr_cpp = '"--mode=c -N -xC120 --style=ansi -pcH".(&expandtab ? "s".&shiftwidth : "t")'

" Ale

nmap <silent> ]w <Plug>(ale_next_wrap)
nmap <silent> [w <Plug>(ale_previous_wrap)

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'python': ['black'],
\   'typescript': ['deno'],
\   'json': ['prettier'],
\   'javascript': ['prettier']
\}

let g:ale_linters = {
\   'python': ['flake8'],
\   'typescript': ['deno']
\}

let g:ale_fix_on_save = 1

" **********************************************************************
" Keybindings

" Autoformat
noremap <leader>b :Autoformat<CR><CR>

" Markdown preview
nnoremap <F3> :MarkdownPreview<CR>

" Time stamp
nnoremap <F5> "=strftime("%F %T")<CR>P

" Shortcuts for copy and paste to system clipboard
vnoremap <C-insert> "+y
nnoremap <S-insert> "+p
inoremap <S-insert> <ESC>"+pa

" **********************************************************************
" File based configurations

" Haskell
function! FormatHaskell()
    execute "!" . "hindent" . " --style cramer " . bufname("%")
    edit!
endfunction

autocmd FileType haskell map <buffer> <localleader>b :call FormatHaskell()<cr><cr>

" Vue (Javascript Framework)
" Prevent random syntax highlight problem
autocmd FileType vue syntax sync fromstart
autocmd FileType vue setlocal indentkeys-=*<Return> indentkeys-={

" Automatically remove trailing white space
" Very usefull when copying code from jupyter notebook
autocmd BufWritePre *.py :%s/\s\+$//e

" Octave setup
autocmd BufRead,BufNewFile *.m set filetype=octave

" Python Syntax
let g:python_highlight_all = 1

" Gradle && Groovy setup
au BufNewFile,BufRead *.gradle setf groovy
au BufNewFile,BufRead *.html.ftl setf html.ftl

" Octave/Matlab setup
autocmd FileType octave syntax sync fromstart
autocmd FileType octave setlocal ts=2 sts=2 sw=2 expandtab

" **********************************************************************
" No longer used

" No long used, only keep for reference.
" Live down
" github: https://github.com/shime/vim-livedown
" nmap <C-p> :LivedownToggle<CR>

" Vim Yaml Formatter
" https://github.com/tarekbecker/vim-yaml-formatter
" autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" autocmd FileType yaml map <buffer> <localleader>b :call YAMLFormat()<cr><cr>
"
"
