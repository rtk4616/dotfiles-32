" vim: fdm=marker:
" Globals {{{
" -------------------------------------------------------------------------------
if !exists('g:chosen_color')
    let g:chosen_color = ""
endif
let s:is_initial=1
if !exists('g:initial_load')
    let g:initial_load=1
else
    let s:is_initial=0
endif

let s:ignore_dirs='\v[\/]((\.(git|hg|svn))|(build|obj|temp))$'
let s:ignore_files='\v\.('
                 \.'meta|exe|so|dll|fbx|png|tga|jpg|bmp|'
                 \.'unityproj|userprefs|suo|asset|prefab|db|dwlt|mdb|class|jar|'
                 \.'mat|apk|obb|cache|controller|user|ttf|guiskin|unity|pyc|o|a|so|dylib'
                 \.')$'
" }}}
" Init globals {{{
" -------------------------------------------------------------------------------
let s:isWin=0
let s:isLinux=0
if has('win32') || has('win64')
  let s:isWin=1
else
  let s:isLinux=1
endif
" }}}
" Mandatory settings {{{
" ------------------------------------------------------------------------------
set nocompatible
filetype indent plugin on
if (s:isWin)
    set shell=cmd
    set shellcmdflag=/c
endif
" }}}
" Mappings {{{
" ------------------------------------------------------------------------------
let mapleader = ","
let maplocalleader = "\\"
if (s:isWin)
    nmap <F2>           :e ~/_vimrc<CR>
    nmap <F3>           :so ~/_vimrc<CR>
    nmap <leader>E      :Start explorer %:h<CR>
    nmap <leader>C      :Start cmd /K cd /d "%:h"<CR>
else
    nmap <F2>           :e ~/.vimrc<CR>
    nmap <F3>           :so ~/.vimrc<CR>
    nmap <leader>E      :Start nautilus %:h<CR>
endif
nmap Q <Nop>

" Toggle cursor column
map <F11> :set cursorcolumn!<CR>

" " Select visual lines by default
" nmap j gj
" nmap k gk

" Swap v and CTRL-v (prefer block mode)
nnoremap    v   <C-V>
nnoremap <C-V>     v
vnoremap    v   <C-V>
vnoremap <C-V>     v

" Fastest insert mode leaving
imap jk <C-C>
imap jK <C-C>
imap Jk <C-C>
imap JK <C-C>

" Quickly remove search highlight
func! ClearSearch()
    call setreg('/', "you will never find me!")
    nohl
endfunc
nmap <F4> :call ClearSearch()<CR>

" Easier copying and pasting
nmap <leader>p "*p
nmap <leader>P "*P
imap <C-_>     <C-R>
vmap <leader>y "*yy

" Start the current file as a command
nmap <leader>e :Start %s:h<CR>

" ':Wa' is not editor command annoyance
command! -bang Wa wa<bang>
command! -bang Wq wq<bang>

" Easier window navigation
nmap <C-H> <C-W>h
nmap <C-J> <C-W>j
nmap <C-K> <C-W>k
nmap <C-L> <C-W>l

" Easier tab navigation
nnoremap <C-S-tab> :tabprevious<CR>
nnoremap <C-tab>   :tabnext<CR>
nnoremap <C-t>     :tabnew<CR>
inoremap <C-S-tab> <Esc>:tabprevious<CR>i
inoremap <C-tab>   <Esc>:tabnext<CR>i
inoremap <C-t>     <Esc>:tabnew<CR>
nnoremap <C-Insert> :tabnew<CR>
nnoremap <C-Delete> :tabclose<CR>
nnoremap <A-F1> 1gt
nnoremap <A-F2> 2gt
nnoremap <A-F3> 3gt
nnoremap <A-F4> 4gt

" Mouse scrolling
map <ScrollWheelUp>     <C-Y>
map <S-ScrollWheelUp>   <C-U>
map <ScrollWheelDown>   <C-E>
map <S-ScrollWheelDown> <C-D>

" Always launch command editing window
" nmap : q:i
" nmap / q:i
" nmap ? q?i

" Faster substitute prompt
" Substitute with last search, confirm on/off
nmap <leader>/ :%s:<C-R>/::g<Left><Left>
" Substitute from blank, confirm on/off
nmap <leader>; :%s:::g<Left><Left><Left>
nmap <leader>' :%s:::gc<Left><Left><Left><Left>

" View last command output (hack)
nmap <leader>s :!cat<CR>

" }}}

" Plugins {{{
" ------------------------------------------------------------------------------
call plug#begin("~/.vim/plugged")
Plug 'flazz/vim-colorschemes'
Plug 'ChrisKempson/Tomorrow-Theme', { 'rtp': 'vim' }
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'Townk/vim-autoclose'
Plug 'mileszs/ack.vim'
Plug 'ivyl/vim-bling'
Plug 'OrangeT/vim-csharp'
Plug 'tpope/vim-haml'
Plug 'derekwyatt/vim-scala'
Plug 'jimenezrick/vimerl'
Plug 'othree/xml.vim'
Plug 'gkz/vim-ls'
Plug 'leafgarland/typescript-vim'
Plug 'Shougo/vimproc.vim'
Plug 'tpope/vim-dispatch'
Plug 'tmux-plugins/vim-tmux'
Plug 'digitaltoad/vim-jade'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-fireplace'
Plug 'felixSchl/python-vim-instant-markdown'
Plug 'raichoo/purescript-vim'

Plug 'OmniSharp/omnisharp-vim'
let g:OmniSharp_timeout = 1
augroup omnisharp_commands
    autocmd!
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
    autocmd FileType cs nnoremap <leader>b :wa!<cr>:OmniSharpBuildAsync<cr>
    autocmd BufWritePost *.cs call OmniSharp#AddToProject()
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
augroup END

nnoremap <leader><space> :OmniSharpGetCodeActions<cr>
vnoremap <leader><space> :call OmniSharp#GetCodeActions('visual')<cr>

nnoremap <leader>nm :OmniSharpRename<cr>
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")
nnoremap <leader>rl :OmniSharpReloadSolution<cr>
nnoremap <leader>cf :OmniSharpCodeFormat<cr>
nnoremap <leader>tp :OmniSharpAddToProject<cr>
nnoremap <leader>ss :OmniSharpStartServer<cr>
nnoremap <leader>sp :OmniSharpStopServer<cr>
nnoremap <leader>th :OmniSharpHighlightTypes<cr>

Plug 'vim-scripts/LargeFile'
let g:LargeFile=50

Plug 'Twinside/vim-hoogle'
au filetype haskell map <buffer> <leader>i :HoogleInfo<CR>
au filetype haskell map <buffer> <F1>      :Hoogle
au filetype haskell map <buffer> <C-F1>    :HoogleClose<CR>
au filetype haskell map <buffer> <S-F1>    :HoogleLine<CR>

Plug 'tomtom/tcomment_vim'
nmap <leader>o <C-O>
nmap <C-i> gccj
vmap <C-i> gc

Plug 'AndrewRadev/switch.vim'
nnoremap - :Switch<CR>

Plug 'Yggdroot/indentLine'
nmap <leader>ir :IndentLinesReset<CR>
nmap <leader>it :IndentLinesToggle<CR>
nmap <F12>      :IndentLinesToggle<CR>
let g:indentLine_noConcealCursor=1

Plug 'godlygeek/tabular'
" Maps hotkeys for tabularize, repeatable by repeat.vim
function! s:make_align_mappings(first_key, ...)
    for tabmaps in a:000
        let second_key = tabmaps[0]
        let tabularize_args = tabmaps[1]
        let tabularize_cmd = ":Tabularize " . tabularize_args
        let repeat_vim_cmd = ":call repeat#set(\"". tabularize_cmd . "<Bslash><lt>CR>\")"
        let keymap_cmd = a:first_key . second_key . " " . tabularize_cmd . "<CR>" . repeat_vim_cmd . "<CR>"
        execute "nnoremap " . keymap_cmd
        execute "vmap " . keymap_cmd
    endfor
endfunc

Plug 'plasticboy/vim-markdown'

call s:make_align_mappings(
    \ "<leader>a"
    \,[':' , "\/:\\zs/l0r1"]
    \,[',' , "\/,\\zs/l0r1"]
    \,['=' , "\/[^=^<^!]=[^=^>]/l0r0"]
    \,['\~', "\/==/l1r1"]
    \,['+' , "\/+/l1r1"]
    \,['-' , "\/-/l1r1"]
    \,['\|', "\/" . '\|' ."/l1r1"]
    \,['\[', "\/\[/l1r1"]
    \,['\]', "\/\]/l1r1"]
    \,['m' , "\/^[^<]*<[^>]*>\\zs/l0r1"]
    \)

Plug 'chrismccord/bclose.vim'
nnoremap <C-W>c :Bclose<CR>

if !s:isWin
    " Too slow on windows...
    Plug 'airblade/vim-gitgutter'
endif

Plug 'bling/vim-airline'
" Disable Tagbar for airline, too slow!
let g:airline#extensions#tagbar#enabled=0

let s:neocomplete=0
if has("lua")
    Plug 'Shougo/neocomplete'
    let s:neocomplete = 1
    let g:neocomplete#use_vimproc = 1
    let g:neocomplete#enable_at_startup = 1
    let g:neocomplete#enable_smart_case = 1
    let g:neocomplete#text_mode_filetypes = {
                                            \ "pandoc": 1
                                            \ }
    if !exists('g:neocomplete#sources#omni#input_patterns')
        let g:neocomplete#sources#omni#input_patterns = {}
    endif
    if !exists('g:neocomplete#sources')
        let g:neocomplete#sources = {}
    endif
    inoremap <expr><C-g>    neocomplete#undo_completion()
    inoremap <expr><C-l>    neocomplete#complete_common_string()
    inoremap <expr><C-h>    neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><BS>     neocomplete#smart_close_popup()."\<C-h>"
    inoremap <expr><C-y>    neocomplete#close_popup()
    inoremap <expr><C-e>    neocomplete#cancel_popup()
else
    Plug 'ervandew/supertab'
endif

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"


Plug 'jondkinney/dragvisuals.vim'
vmap  <expr>  <S-LEFT>   DVB_Drag('left')
vmap  <expr>  <S-RIGHT>  DVB_Drag('right')
vmap  <expr>  <S-DOWN>   DVB_Drag('down')
vmap  <expr>  <S-UP>     DVB_Drag('up')
vmap  <expr>  D          DVB_Duplicate()

Plug 'scrooloose/syntastic'
let g:syntastic_check_on_wq=0
let g:syntastic_mode_map = { 'mode': 'passive'
                           \,'active_filetypes': []
                           \,'passive_filetypes': []
                           \}
nmap <silent> <leader>ss :SyntasticCheck<CR>
nmap <silent> <leader>sr :SyntasticReset<CR>

let g:syntastic_haskell_checkers = ['hlint']
let g:syntastic_cs_checkers      = ['syntax', 'semantic', 'issues']

Plug 'vim-pandoc/vim-pandoc-syntax'
let g:pandoc_use_embeds_in_codeblocks_for_langs = [
    \ "python"
    \,"cs"
    \,"haskell"
    \ ]

Plug 'vim-scripts/glsl.vim'
au BufNewFile,BufRead *.shader set filetype=glsl.c

Plug 'dhruvasagar/vim-table-mode'
let g:table_mode_corner = '+'

Plug 'scrooloose/nerdtree'
nmap <F6> :call g:Vimrc_toggle_nerd_tree()<CR>
let g:vimrc_initial_nerd_tree=1
function! g:Vimrc_toggle_nerd_tree()
    if (g:vimrc_initial_nerd_tree==1)
        execute ":NERDTreeCWD"
        let g:vimrc_initial_nerd_tree=0
    else
        execute ":NERDTreeToggle"
    endif
endfunc
let g:NERDTreeHighlightCursorline=1
let g:NERDTreeWinPos="right"
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeMinimalUI=1
let g:NERDTreeIgnore = [
    \ s:ignore_files . '[[file]]'
    \,s:ignore_dirs . '[[dir]]'
    \ ]
autocmd FileType nerdtree call s:nerdtree_settings()
function! s:nerdtree_settings()
    let &nu=0
    let &relativenumber=0
endfunc
nnoremap <leader>ff :NERDTreeFind<CR>

Plug 'nelstrom/vim-visual-star-search'
Plug 'thinca/vim-visualstar'
nmap * <Plug>(visualstar-*)N

Plug 'milkypostman/vim-togglelist'
nmap <script> <silent> <leader>l :call ToggleLocationList()<CR>
nmap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>

Plug 'tyru/open-browser.vim'
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

Plug 'kien/ctrlp.vim'
let g:ctrlp_max_depth = 20
let g:ctrlp_map = '<C-P>'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cmd = 'CtrlPCurWD'
let g:ctrlp_custom_ignore = {
    \ 'dir':  s:ignore_dirs,
    \ 'file': s:ignore_files
    \ }
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript',
                        \ 'undo', 'line', 'changes', 'mixed', 'bookmarkdir'
                        \ ]
nnoremap <silent> <C-B> :CtrlPBuffer<CR>
nnoremap <leader>fr     :CtrlPMRU<CR>
nnoremap <leader>fb     :CtrlPBookmarkDir<CR>
nnoremap <leader>fd     :execute ":CtrlPDir ".fnameescape(getcwd()) <CR>
nnoremap <leader>fs     :CtrlPRTS<CR>
nnoremap <leader>fu     :CtrlPUndo<CR>
nnoremap <leader>fl     :CtrlPLine<CR>

Plug 'dbakker/vim-projectroot'
nnoremap <leader>cd :ProjectRootCD<cr>

call plug#end()
" }}}
" Global preferences {{{
" ------------------------------------------------------------------------------
set foldlevelstart=20
set mouse=
if (s:is_initial)
    syntax on
endif
" set noswapfile
set history=100000
set noshowmatch
set updatetime=500
set completeopt=longest,menuone,preview
set cmdheight=2
set splitbelow
set lazyredraw
set sessionoptions-=options
set sessionoptions-=folds
set viminfo='50,<1000,s100,n~/.viminfo
set autoindent
set backspace=indent,eol,start
set complete-=1
set showmatch
set smarttab
set nrformats-=octal
set shiftround
set ttimeout
set ttimeoutlen=50
set exrc
set hidden
set nospell
set showcmd
set incsearch
set hlsearch
set number
set norelativenumber
set nowrap
set ruler
set linebreak
let &showbreak='... '
set cursorline
set ignorecase
set smartcase
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set textwidth=80
set foldmethod=syntax
set foldlevelstart=99
set formatoptions-=t
" set foldcolumn=3
autocmd FileType qf wincmd J " quickfix list at bottom
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swp
set wildignore+=*.png,*.tga,*.psd
set wildignore+=*.class,*.jar
set wildignore+=*.meta,*.prefab
set suffixes+=.class,.exe,.o,.obj,.dat,.dll,.aux,.pdf,.gch
set wildmenu
set wildmode=longest:list,full
set laststatus=2
set ttimeoutlen=50
set enc=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc
exec "set listchars=tab:\\|→"
exec "set list lcs+=trail:\uB7,nbsp:~"
" }}}
" Theme  {{{
" ------------------------------------------------------------------------------
set colorcolumn=+1

" Random Colors {{{2
func! Rand(lower, upper)
" Gets random number in range (lower, upper)
python << EOF
import vim, random
r = random.randint(int(vim.eval('a:lower')), int(vim.eval('a:upper')))
vim.command('return ' + str(r))
EOF
endfunc

func! SetRandomColorScheme(colors)

    let color = ""

    if (g:chosen_color != "")
        let color = g:chosen_color
    else
        let color = a:colors[Rand(0, len(a:colors) - 1)]
    endif

    " Load the color scheme
    execute 'colorscheme ' . color
    let g:chosen_color = g:colors_name

    " Cursor line default colors
    let cursor_line_normal_bg = "#333333"
    let cursor_line_insert_bg = "#002143"

    hi! link Conceal SpecialKey

    " Overwrites
    if (g:colors_name == "molokai")
        hi! link ColorColumn WarningMsg
    elseif (g:colors_name == "candyman")
        let cursor_line_normal_bg = "#222222"
        hi! link ColorColumn SpecialKey
    elseif (g:colors_name == "jellybeans")
        let cursor_line_normal_bg = "#222222"
        hi! link ColorColumn SpecialKey
    elseif (g:colors_name == "xoria256")
        hi! link ColorColumn VertSplit
    elseif (g:colors_name == "herald")
        if has("gui_running")
            hi! link ColorColumn StatusLine
        else
            hi! link ColorColumn StatusLineNC
        endif
    elseif (g:colors_name == "lilypink")
        hi! link ColorColumn StatusLineNC
    elseif (g:colors_name == "wombat256mod")
        hi! link ColorColumn SpecialKey
    elseif (g:colors_name == "inkpot")
        hi! link ColorColumn LineNr
    elseif (g:colors_name == "pf_earth")
        hi! link ColorColumn LineNr
    elseif (g:colors_name == "kolor")
        hi! link ColorColumn LineNr
    elseif (g:colors_name == "graywh")
    endif

    " Set the cursor line color
    execute "hi! CursorLine guibg=".cursor_line_normal_bg." guifg=NONE"
    execute "au InsertEnter * hi! CursorLine guibg=".cursor_line_insert_bg." guifg=NONE"
    execute "au InsertLeave * hi! CursorLine guibg=".cursor_line_normal_bg." guifg=NONE"

endfunc
" }}}2

if has("gui_running")

    call SetRandomColorScheme([
        \  'jellybeans'
        \, 'lilypink'
        \, 'wombat256mod'
        \, 'kolor'
        \, 'herald'
    \])

    " TagHighlight classes
    highlight Class guifg=#5199C0
    highlight LocalVariable guifg=#ffffff
    highlight Function guifg=#F4F885

    if (s:isWin)
        set guifont=Consolas:h12:cANSI
    else
        set guifont=Monaco
    endif
    set guifontwide=NSimsun:h12
    set guioptions-=m
    set guioptions-=e
    set guioptions+=c
    set guioptions-=l
    set guioptions-=L
    set guioptions-=r
    set guioptions-=R
    set guioptions-=b
    set guioptions-=T
else
    set t_Co=256
    if (s:isLinux)
        call SetRandomColorScheme([
            \  'xoria256'
            \, 'jellybeans'
            \, 'kolor'
            \, 'herald'
            \, 'Tomorrow-Night'
            \, 'Tomorrow-Night-Eighties'
            \, 'Tomorrow-Night-Bright'
        \])
    endif
    hi CursorLine term=NONE cterm=NONE ctermbg=236
endif
" }}}
" Filetypes {{{
" ------------------------------------------------------------------------------
" Adobe extend script 
autocmd BufRead,BufNewFile *.jsx setlocal filetype=javascript
autocmd BufRead,BufNewFile *.jsxinc setlocal filetype=javascript
autocmd BufRead,BufNewFile *.mxi setlocal filetype=xml

" CSharp
autocmd BufRead,BufNewFile *.cshtml setlocal filetype=xml.javascript

" Livescript
autocmd BufRead,BufNewFile *.ls setlocal filetype=ls

" ActionScript3
autocmd BufRead,BufNewFile *.as setlocal filetype=as3

" Java
let java_highlight_all=1
let java_highlight_debug=1
autocmd filetype java setlocal suffixesadd+=.java

" Unity Shaders
autocmd BufRead,BufNewFile *.shader setlocal filetype=cg

" Dart
autocmd BufRead,BufNewFile *.dart setlocal filetype=dart

" HTML
autocmd filetype html setl shiftwidth=2

" Typescript
au BufRead,BufNewFile *.ts setl filetype=typescript

" Python
autocmd filetype python setlocal foldmethod=indent
autocmd filetype python nnoremap <buffer> <F7> :exe "w \| !python %"<CR>

" Ruby
autocmd filetype ruby setl shiftwidth=2

" Rails asset pipeline
autocmd BufRead,BufNewFile *.slim set filetype=slim

" Markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.mdown set filetype=markdown
autocmd BufRead,BufNewFile *.markdown set filetype=markdown

" Haskell
au filetype haskell nmap <script> <buffer> <localLeader>r :!runhaskell %<CR>
au filetype haskell nnoremap <script> <buffer> <LocalLeader>t :HdevtoolsType<CR>
au filetype haskell nnoremap <buffer> <F7> :exe "w \| !runhaskell %"<CR>
au filetype haskell setl omnifunc=necoghc#omnifunc

" }}}
" Goodies {{{
" ------------------------------------------------------------------------------

" Quit immediately
nmap <C-X><C-X> :qal!<CR>

" Open a help in a vertsplit. Use with `:Vh`
command! -nargs=* -complete=help Vh vertical belowright help <args>

" Bind the last run command to a hotkey
" e.g.: :BindLast <F7>
func! BindCommand(key)
    let b:cmd  = histget('cmd', -2)
    let b:comp = ":w! \\| ".b:cmd
    exec ":nmap ".a:key." :exe \"".b:comp."\"<CR>"
endfunc
command! -nargs=+ BindLast :call BindCommand(<q-args>)

au FileType javascript nmap <F7> :exe ":w! \| !node %"<CR>
au FileType clojure nmap <F7> :exe ":%Eval"<CR>

" Working directory per tab
au TabEnter * if exists("t:wd") | exe "cd " . fnameescape(t:wd) | endif
au TabLeave * let t:wd=getcwd()

" }}}
" Tracking {{{
" ------------------------------------------------------------------------------
func! TrackerAddItem()
    let b:ve=&ve
    set ve=all
    execute 'normal 0$  v80|r-$hhhhxxxxx iOPEN'
    let &ve=b:ve
    unlet! b:ve
endfunc

func! TrackerCloseItem()
    execute 'normal 0 /OPEN$/
endfunc

func! TrackerOpenItem()
    execute 'normal 0 /DONE$/
endfunc

nmap <silent> <leader>ma        :call TrackerAddItem()<CR>
nmap <silent> <leader>mc        :call TrackerCloseItem()<CR>
nmap <silent> <leader>mo        :call TrackerOpenItem()<CR>
vmap <silent> <leader>ma        :call TrackerAddItem()<CR>
vmap <silent> <leader>mc        :call TrackerCloseItem()<CR>
vmap <silent> <leader>mo        :call TrackerOpenItem()<CR>
" }}}
