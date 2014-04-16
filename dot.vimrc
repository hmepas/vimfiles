" vim: set ft=vim : set fileencoding=utf-8 :

set nocompatible

" ORDER IS MATTER, THIS OPTION SHOULD BE FIRST TO AVOID 
" UNECCESSARY CONVERSIONS WHICH COULD BE BROKEN
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,cp1251,latin1

version 6.
map Q gq
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)

set hidden
set background=dark
"set diffexpr=MyDiff()
set helplang=ru
set history=50
set hlsearch
set incsearch
set keymodel=startsel,stopsel
" always show current pos
set ruler
set selection=exclusive
set whichwrap=b,s,<,>,[,]

if has("gui_running")
    set selectmode=mouse,key
    set window=78
    set columns=114
    set lines=40
" Font
    set guifont=Lucida_Console:h10:cDEFAULT
    set guifontwide=Lucida_Console:h9:cDEFAULT
endif

" MINE
syntax on
set autoindent
set expandtab

set list " view of unpritable character
if &encoding == 'utf-8'
    if has("gui_running")
        let &listchars="tab:\u251c\u2500,trail:\u00b7,precedes:\u00ab,extends:\u00bb"
    else
        set listchars=tab:├─,trail:·
    endif
else
    set listchars=tab:>\ ,trail:.
endif
let &sbr = nr2char(9658)

set shiftwidth=4
set tabstop=4
set softtabstop=4

set pastetoggle=<F2>

let perl_fold=1
let perl_include_pod = 1
let perl_want_scope_in_variables = 1

let Tlist_Inc_Winwidth = 0
map <F3> :Tlist<CR>

"colors torte

" export TERM=xterm-256color
let g:solarized_termcolors = 256
let g:solarized_visibility = "normal"
let g:solarized_contrast = "normal"

set nobackup

filetype plugin on

" switch for search higlighting
set hlsearch!
nnoremap <F7> :set hlsearch!<CR>


" To avoid permission change
" http://vimdoc.sourceforge.net/htmldoc/vimfaq.html 
" 7.3. issue
set backupcopy=yes

"HTML::Mason syntax enable
au BufNewFile,BufRead *.msn set ft=mason
au Filetype mason set foldmethod=manual

" some tweaks for xml.vim
let xml_use_xhtml = 1

set ignorecase
set smartcase

" insert mode motions, just in case
inoremap <A-h> <C-o>h
inoremap <A-j> <C-o>j
inoremap <A-k> <C-o>k
inoremap <A-l> <C-o>l
" just to not load my mind with edition mode to much
noremap <A-h> h
noremap <A-j> j
noremap <A-k> k
noremap <A-l> l

" Ctrl-<ENTER> for inserting new line
nmap <c-cr> i<cr><Esc>

" Hide toolbar and menu
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar

" view line nubmer
set number
set numberwidth=1
set cursorline "?

" my highlighting
hi SpecialKey guifg=DarkCyan
hi LineNr guifg=DarkGray
hi StatusLine guifg=Gray guibg=white

" When joining lines only add one space after a sentence.
set nojoinspaces

" visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv 

" autowrap comments
set formatoptions-=c

if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\   " Filename
        set statusline+=%w%h%m " Options
"        set statusline+=%{fugitive#statusline()} "  Git Hotness
        set statusline+=\ [%{(&fenc\ ==\ \"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}] " fileencoding
        set statusline+=\ [%{&ff}/%Y]            " filetype
        "set statusline+=\ [%{getcwd()}]          " current dir
        set statusline+=\ [0x\%02.2B\ \U+%04B] " ASCII / Hexadecimal value of char
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
        let g:ctags_statusline=1
        let g:ctags_title=1
endif

let g:user_zen_settings = {
\  'mason' : {
\    'extends' : 'html',
\  },
\  'php' : {
\    'extends' : 'html',
\    'filters' : 'c',
\  },
\  'xml' : {
\    'extends' : 'html',
\  },
\  'haml' : {
\    'extends' : 'html',
\  },
\}

" Pathogen launch
execute pathogen#infect()

source $HOME/.vimrc-lang-remap
colors solarized
