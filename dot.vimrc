" vim: set ft=vim : set fileencoding=utf-8 :

set nocompatible

" VUNDLE SETUP
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Plugin 'altercation/vim-colors-solarized'
Plugin 'benmills/vimux'
Plugin 'scrooloose/syntastic'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'majutsushi/tagbar'
Plugin 'kien/ctrlp.vim'
Plugin 'git://repo.or.cz/vcscommand'
Plugin 'dbakker/vim-projectroot.git'
Plugin 'junkblocker/patchreview-vim'
Plugin 'mileszs/ack.vim'
Plugin 'jeetsukumaran/vim-markology'
Plugin 'mhinz/vim-signify'
Plugin 'Konfekt/FastFold'
Plugin 'tmhedberg/SimpylFold'

" / VUNDLE SETUP

" Plug setup
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" then :PluginInstall
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'vim-perl/vim-perl', { 'for': 'perl' }
call plug#end()
" / Plug setup

filetype plugin on

let mapleader=","

" Syntastic check
let g:syntastic_perl_checkers = ['perl']
let g:syntastic_enable_perl_checker = 1
let g:syntastic_enable_signs = 1
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
command Scheck :SyntasticToggleMode
command Blame :VCSBlame

function FixPerlIncludes()
    if filereadable(expand("~/bin/perl_incl"))
        let perl_paths_string = system("~/bin/perl_incl " . expand('%:p'))
"        echom perl_paths_string
        let g:syntastic_perl_lib_path = split(perl_paths_string, ';')
    endif
endfunction

au FileType perl call FixPerlIncludes()
au FileType perl let g:syntastic_auto_loc_list = 1
au FileType perl let perl_fold = 1
au FileType perl let perl_include_pod = 1
set foldlevelstart=1
" use dbakker/vim-projectroot.git
au FileType perl call SetTags()

" tmhedberg/SimpylFold
au FileType python let let g:SimpylFold_docstring_preview = 1

function SetTags()
    if filereadable('./tags')
        let &tags='./tags;'
    else
        let pr_tags = ProjectRootGuess().'/tags'
        if filereadable(pr_tags)
            let &tags=pr_tags.';'
        endif
    endif
endfunction

" find module in perl INC and edit
" kudos to davewood http://blogs.perl.org/users/davewood/2012/06/open-module-under-cursor-in-vim.html#comment-162561
function! EditModule()
    let cw = expand("<cWORD>")
    let fname = substitute( system( "perldoc -lm " . cw ), "\n", '', '' )
    if filereadable( fname )
        exec "edit " . fname
    else
        echo "File not found or not readable (" . fname . ")"
    endif
endfunction

au FileType perl nmap fm :call EditModule()<CR>
" / end of finding module in perl sources

" so :tag will works on methods with package prefix
au Filetype perl set iskeyword=@,48-57,_,192-255 " no : symbol

" mileszs/ack.vim plugin ag support
if executable('ag') == 1
    let g:ackprg = 'ag --vimgrep --smart-case'
    " since those conflicts wit fzf
    if executable('fzf') != 1
        cnoreabbrev ag Ack
        cnoreabbrev aG Ack
        cnoreabbrev Ag Ack
        cnoreabbrev AG Ack
        " search current under cursor word in project root
        nnoremap <silent> <Leader>* :exe ':Ack! <cword>' projectroot#guess()<cr>
    endif
endif
" / end of mileszs/ack.vim settings

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#fnamecollapse = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
let g:airline#extensions#tabline#buffer_min_count = 2

let g:airline#extensions#syntastic#enabled = 1

let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#whitespace#checks = []

let g:airline_powerline_fonts = 1

"let g:airline_theme = "hybrid"
"let g:airline_theme = "luna"
let g:airline_theme = "lucius"

" fzf stuff
" CtrlP swapped for fzf, overwise fallback to ctrlp
if executable('fzf') == 1
    let g:ctrlp_map = '<Leader><c-p>'
    let g:fzf_buffers_jump = 1
    let g:fzf_layout = { 'down': '~30%' }
    nnoremap <silent> <Leader>* :call fzf#vim#ag('<C-R><C-W>', {'down' : '~20%', 'dir': projectroot#guess()})<CR>
    nnoremap <c-p> :call fzf#vim#files(projectroot#guess())<CR>
else
    let g:ctrlp_max_depth = 20
    let g:ctrlp_max_files = 0
    if executable('ag') == 1
        let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
          \ --ignore .git
          \ --ignore .svn
          \ --ignore .hg
          \ --ignore .DS_Store
          \ --ignore "**/*.pyc"
          \ -g ""'
    else
        let g:ctrlp_clear_cache_on_exit=0
        au Filetype perl let g:ctrlp_user_command = 'find %s -type f -regextype posix-basic -regex ".\+\.p[ml]"'
    endif
endif
" ORDER IS MATTER, THIS OPTION SHOULD BE FIRST TO AVOID
" UNECCESSARY CONVERSIONS WHICH COULD BE BROKEN
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,cp1251,latin1

version 6.
map Q gq
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)

" don't search for autocomplete in included files
set complete-=i

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

set mouse=a

if has("gui_running")
    set selectmode=mouse,key
    set window=78
    set columns=114
    set lines=40
" Font
    "set guifont=Lucida_Console:h10:cDEFAULT
    "set guifontwide=Lucida_Console:h9:cDEFAULT
    "set guifont=Consolas:h11:cDEFAULT
    "set guifontwide=Consolas:h9:cDEFAULT
    "set guifont=DejaVu_LGC_Sans_Mono:h11:cRUSSIAN
    "set guifontwide=DejaVu_LGC_Sans_Mono:h11:b:cRUSSIAN
    set guifont=DejaVu_Sans_Mono_for_Powerline:h12
    set guifontwide=DejaVu_Sans_Mono_Bold_for_Powerline:h12
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

let perl_want_scope_in_variables = 1
let xml_syntax_folding = 1

" let Tlist_Inc_Winwidth = 0
"au FileType perl TlistUpdate " if we want current sub without statusline-air
"
" Tagbar
" map <F3> :TList<CR>
nnoremap <silent> <F3> :call TagbarSmartToggle()<CR>
function TagbarSmartToggle()
    let tagbarwinnr = bufwinnr("__Tagbar__")
    if tagbarwinnr != -1
        execute ':TagbarClose'
    else
        execute ':TagbarOpenAutoClose'
    endif
endfunction
let g:tagbar_left = 1
let g:tagbar_compact = 1
let g:tagbar_singleclick = 1
let g:tagbar_autopreview = 1


"colors torte

" export TERM=xterm-256color
let g:solarized_termcolors = 256
let g:solarized_visibility = "normal"
let g:solarized_contrast = "normal"

set nobackup


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
au Filetype xml set iskeyword=@,48-57,_,192-255 " no : symbol
au Filetype xml set foldmethod=syntax

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
        "set statusline+=\ [%{Tlist_Get_Tagname_By_Line(bufname(%), getline('.'))}] " current method
        set statusline+=\ %{Tlist_Get_Tagname_By_Line()}() " current method
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

" Vimux
map <Leader>vp :VimuxPromptCommand<CR>
map <Leader>vi :VimuxInspectRunner<CR>
map <Leader>vl :VimuxRunLastCommand<CR>
map <Leader>vz :call VimuxZoomRunner()<CR>
map <Leader>vq :VimuxCloseRunner<CR>

" buffers navigation
map <Leader>n :bn<CR>
map <Leader>p :bp<CR>
if g:airline#extensions#tabline#enabled
    nmap <leader>1 <Plug>AirlineSelectTab1
    nmap <leader>2 <Plug>AirlineSelectTab2
    nmap <leader>3 <Plug>AirlineSelectTab3
    nmap <leader>4 <Plug>AirlineSelectTab4
    nmap <leader>5 <Plug>AirlineSelectTab5
    nmap <leader>6 <Plug>AirlineSelectTab6
    nmap <leader>7 <Plug>AirlineSelectTab7
    nmap <leader>8 <Plug>AirlineSelectTab8
    nmap <leader>9 <Plug>AirlineSelectTab9
else
    nmap <Leader>1 :b 1<CR>
    nmap <Leader>2 :b 2<CR>
    nmap <Leader>3 :b 3<CR>
    nmap <Leader>4 :b 4<CR>
    nmap <Leader>5 :b 5<CR>
    nmap <Leader>6 :b 6<CR>
    nmap <Leader>7 :b 7<CR>
    nmap <Leader>8 :b 8<CR>
    nmap <Leader>9 :b 9<CR>
endif

command CpMode call CpMode()
function CpMode()
    set nolist
    set nonu
    execute ':MarkologyDisable'
endfunction

" highlight word under cursor
autocmd CursorMoved * exe exists("HlUnderCursor")?HlUnderCursor?printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\')):'match none':""
nnoremap <silent> <F4> :exe "let HlUnderCursor=exists(\"HlUnderCursor\")?HlUnderCursor*-1+1:1"<CR>

source $HOME/.vimrc-lang-remap
colors solarized

" speedup stuff
" do
" :syntax off
" :set synmaxcol=120
" if nothing helps
set synmaxcol=512
set ttyfast " u got a fast terminal
set ttyscroll=3
set lazyredraw " to avoid scrolling problems

" speedup method for that
command Speed call Speed()
function Speed()
    set nocursorline
    set foldmethod=indent
    execute ':syntax off'
endfunction
" / speedup stuff

" ShowMarks with solarized
hi Visual cterm=NONE ctermbg=0 ctermfg=NONE guibg=Grey40

" Markology support, better looking SignColumn
hi! link SignColumn   LineNr
hi! link MarkologyHLl DiffAdd
hi! link MarkologyHLu DiffChange
hi! link MarkologyHLo DiffAdd
hi! link MarkologyHLm DiffChange

" Better looking popup menu (for omnicomplete)
hi! link PMenu DiffAdd
hi! link PMenuSel DiffChange
hi! link PMenuSbar DiffAdd
hi! link PMenuThumb DiffAdd

" This is a better cursor
hi! link Cursor VisualNOS

" Colors to make LustyJuggler more usable
" the Question color in LustyJuggler is mapped to
" the currently selected buffer.
hi! clear Question
hi! Question guifg=yellow

hi! link TagListFileName  Question

" For jasmine.vim
hi! link specFunctions rubyDefine
hi! link specMatcher rubyConstant
hi! link specSpys rubyConstant

" For vimscript, don' tlike red..
hi! link vimMapModKey Operator
hi! link vimNotation Label

" Better json highlighting
hi! link htmlArg Label

" Load local vimrc if present
let local_vimrc_file = $HOME . "/.vim/vimrc.local"
if filereadable(local_vimrc_file)
    execute 'source ' . local_vimrc_file
endif

let g:signify_vcs_list = [ 'svn', 'git', 'hg' ]

" yank to clipboard
if has('clipboard')
    set clipboard=unnamed " copy to the system clipboard
endif
