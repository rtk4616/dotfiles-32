" Personal vim configuration
" Author: Felix schlitter <felixschlitter@gmail.com>
" Source: https://github.com/felixSchl/dotfiles

set nocompatible
filetype indent plugin on
let g:loaded_matchparen = 1

let mapleader = "\<SPACE>"
let maplocalleader = ','

" Detect the operating system
let s:is_windows = has('win32') || has('win64')
let s:is_linux = 0
let s:is_osx = 0
if has("unix")
  let s:uname = system('uname -s')
  if s:uname == 'Darwin'
    let s:is_osx = 1
  else
    let s:is_linux = 1
  endif
endif

let s:ignore_dirs='\v[\/]((\.(git|hg|svn))|(build|obj|temp))$'

let s:ignore_files=''
\'\v\.('
\.'meta|exe|so|dll|fbx|png|tga|jpg|bmp|csproj|sln|'
\.'unityproj|userprefs|suo|asset|prefab|db|dwlt|mdb|class|jar|'
\.'mat|apk|obb|cache|controller|user|ttf|guiskin|unity|pyc|o|a|so|dylib'
\.')$'

" Edit / reload vimrc
nnoremap <F2> :e ~/.vimrc<CR>
nnoremap <F3> :so ~/.vimrc<CR>

" Swap v and CTRL-v (prefer block mode)
nnoremap    v   <C-V>
nnoremap <C-V>     v
vnoremap    v   <C-V>
vnoremap <C-V>     v

" Delete non-selected text from the buffer
map <F5> :<C-U>1,'<-1:delete<CR>:'>+1,$:delete<CR>

" use :w!! to write a file with sudo
cmap w!! w !sudo dd of=%

" Fastest insert mode leaving
imap jk <C-C>
imap jK <C-C>
imap Jk <C-C>
imap JK <C-C>

" Emacs-like control-g to cancel things
nmap <C-G> <C-C>

" Easier copying and pasting
" Copy and paste from the system register `*`
nmap <leader>pp "*p
nmap <leader>PP "*P

" Quickly remove search highlight
func! ClearSearch()
  call setreg('/', "you will never find me!")
  nohl
endfunc
nnoremap <F4> :call ClearSearch()<CR>
nnoremap <leader>cs :call ClearSearch()<CR>

" ':Wa' is not editor command annoyance
command! -bang Wa  wa<bang>
command! -bang Wq  wq<bang>
command! -bang Qal qal<bang>

" View last command output (hack)
nnoremap <leader>s :!cat<CR>

" Run things
nnoremap [run] <Nop>
nmap <leader>r [run]
nnoremap [run]b :!npm run build<CR>
nnoremap [run]t :!npm test<CR>

" Neovim - escape terminal mode
if has('nvim')
  tnoremap jk <C-\><C-n>
endif

" Plugins {{{
" ------------------------------------------------------------------------------
call plug#begin('~/.vim/plugged')
Plug 'xolox/vim-misc'
Plug 'notpratheek/vim-luna'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'gkz/vim-ls', { 'for': 'livescript' }
Plug 'tpope/vim-dispatch'
Plug 'raichoo/purescript-vim', { 'for': 'purescript' }
Plug 'felixschl/vim-gh-preview', { 'for': 'markdown' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'jamescarr/snipmate-nodejs', { 'for': [ 'javascript', 'typescript' ] }
Plug 'guileen/vim-node-dict', { 'for': [ 'javascript', 'typescript' ] }
Plug 'myhere/vim-nodejs-complete', { 'for': [ 'javascript', 'typescript' ] }
Plug 'tpope/vim-unimpaired'
Plug 'Valloric/MatchTagAlways', { 'for': [ 'xml', 'html' ] }
Plug 'tpope/vim-ragtag', { 'for': [ 'xml', 'html' ] }
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/mediawiki.vim', { 'for': 'mediawiki' }
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'evanmiller/nginx-vim-syntax', { 'for': 'nginx' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'wellle/targets.vim'
Plug 'gregsexton/gitv'
Plug 'idanarye/vim-merginal'
Plug 'sheerun/vim-polyglot'
Plug 'Konfekt/FastFold'
Plug 'FrigoEU/psc-ide-vim'
Plug 'tomtom/tcomment_vim'
Plug 'szw/vim-maximizer'
Plug 'pbrisbin/vim-syntax-shakespeare'
Plug 'joshdick/onedark.vim'
Plug 'ElmCast/elm-vim'
Plug 'gregsexton/gitv'
Plug 'neovimhaskell/haskell-vim'
Plug 'eagletmt/ghcmod-vim'
Plug 'bitc/vim-hdevtools'
Plug 'eagletmt/neco-ghc'

let g:AutoCloseExpandSpace = 0
Plug 'Townk/vim-autoclose'

Plug 'elzr/vim-json', { 'for': 'json' }
let g:vim_json_syntax_conceal = 0

Plug 'editorconfig/editorconfig-vim'
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

Plug 'Shougo/vimfiler.vim', { 'on':  [ 'VimFilerBufferDir', 'VimfFiler' ]}
let g:loaded_netrwPlugin = 1
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_ignore_filters = [ 'matcher_ignore_pattern',
                                \ 'matcher_ignore_wildignore']
let g:vimfiler_safe_mode_by_default = 0
nmap - :VimFilerBufferDir -project -find -fnamewidth=80<CR>

" Start vimfiler automatically if no files given
function! ShowVimFiler()
  if !argc()
    if getcwd() =~? '[[:alpha:]]:\\windows\\system32'
      cd ~
      VimFiler -fnamewidth=80
    else
      VimFiler -project -find -fnamewidth=80
    endif
  elseif argc() == 1 && isdirectory(argv(0))
    let dir=xolox#misc#path#absolute(argv(0))
    args!
    exe 'VimFiler -fnamewidth=80 "' . dir . '"'
  endif
endfunction

augroup vimrc_vimfiler
  au!
  au VimEnter * call ShowVimFiler()
  au FileType vimfiler nnoremap <silent><buffer> u :Unite
    \ -profile-name=files
    \ -buffer-name=git-files
    \ file_rec/git:--cached:--others:--exclude-standard:--recursive
    \ <CR>
augroup END

function! BuildVimproc(info)
  if s:is_osx
    !make -f make_mac.mak
  elseif s:is_linux
    !make
  elseif s:is_windows
    " TODO: Compile for windows
  endif
endfunction

Plug 'Shougo/vimproc.vim', { 'do': function('BuildVimproc') }

Plug 'Quramy/tsuquyomi', { 'for': 'typescript' }
let g:tsuquyomi_use_local_typescript=1

Plug 'leafgarland/typescript-vim', { 'for': 'typescript' }
let g:typescript_indent_disable=1

Plug 'junegunn/vim-easy-align'
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
let g:easy_align_delimiters = {
\ '-': { 'pattern': '-' }
\ }

Plug 'junegunn/rainbow_parentheses.vim'
augroup rainbow
  autocmd!
  autocmd FileType * RainbowParentheses
augroup END

Plug 'vim-scripts/LargeFile'
let g:LargeFile=1

" Plug 'Twinside/vim-hoogle', { 'for': 'haskell' }
" au filetype haskell map <buffer> <leader>i :HoogleInfo<CR>
" au filetype haskell map <buffer> <F1>      :Hoogle
" au filetype haskell map <buffer> <C-F1>    :HoogleClose<CR>
" au filetype haskell map <buffer> <S-F1>    :HoogleLine<CR>

Plug 'AndrewRadev/switch.vim'
nnoremap + :Switch<CR>

Plug 'Yggdroot/indentLine'
nnoremap <leader>ir :IndentLinesReset<CR>
nnoremap <leader>it :IndentLinesToggle<CR>
nnoremap <F12>      :IndentLinesToggle<CR>
let g:indentLine_color_term = 233
let g:indentLine_noConcealCursor = 1
let g:indentLine_char = '|'
let g:indentLine_fileTypeExclude = ['thumbnail', 'json', 'markdown']

Plug 'chrismccord/bclose.vim'
nnoremap <C-W>c :Bclose<CR>

" if !s:is_windows
"   Plug 'airblade/vim-gitgutter'
"   nmap <leader>th :GitGutterLineHighlightsToggle<CR>
" endif

Plug 'itchyny/lightline.vim'

let g:lightline = {
\   'component': {
\     'lineinfo': '%3l:%-2v',
\   },
\   'active': {
\     'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ],
\     'right': [ [ 'syntastic', 'lineinfo' ], ['percent'],
\                [ 'fileformat', 'fileencoding', 'filetype' ],
\              ]
\   },
\   'component_function': {
\     'readonly':     'LightLineReadonly',
\     'fugitive':     'LightLineFugitive',
\     'filename':     'ResolveStatusbarFilepath',
\     'modified':     'LightLineModified',
\     'fileformat':   'LightLineFileformat',
\     'filetype':     'LightLineFiletype',
\     'fileencoding': 'LightLineFileencoding',
\     'mode':         'LightLineMode',
\   },
\   'component_type': {
\      'syntastic': 'error',
\    },
\ }

function! LightLineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? 'RO' : ''
endfunction

function! ResolveStatusbarFilepath()
  let dir=fugitive#extract_git_dir(expand('%:p'))
  if dir !=# ''
    " remove `.git` from the end:
    let dir = strpart(dir, 0, len(dir) - 4)
    let filepath = fnamemodify(expand('%'), ":.")
    return substitute(filepath, dir, '', '')
  else
    return pathshorten(fnamemodify(expand('%'), ":."))
  endif
endfunction

function! LightLineFilename()
  let ro = (LightLineReadonly() != '' ? LightLineReadonly() . ' ' : '')
  let special =
      \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
      \  &ft == 'unite' ? unite#get_status_string() :
      \  &ft == 'vimshell' ? vimshell#get_status_string() : '')
  let modified = LightLineModified() != '' ? ' ' . LightLineModified() : ''
  let filepath = call ResolveStatusbarFilepath()
  let filepath = filepath != '' ? filepath : '[No Name]'
  return ro . special . filepath .  modified
endfunction

function! LightLineFugitive()
  if exists('*fugitive#head')
      let _ = fugitive#head()
      return strlen(_) ? ' '._ : ''
  endif
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

if !has('nvim') && has('lua')
  Plug 'Shougo/neocomplete'
  let g:neocomplete#use_vimproc=1
  let g:neocomplete#enable_at_startup=1
  let g:neocomplete#enable_smart_case=1
  let g:neocomplete#text_mode_filetypes={ "pandoc": 1 }
  if !exists('g:neocomplete#sources#omni#input_patterns')
      let g:neocomplete#sources#omni#input_patterns={}
  endif
  if !exists('g:neocomplete#sources')
      let g:neocomplete#sources={}
  endif
  inoremap <expr><C-G> neocomplete#undo_completion()
  inoremap <expr><C-L> neocomplete#complete_common_string()
  inoremap <expr><C-H> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-Y> neocomplete#close_popup()
  inoremap <expr><C-E> neocomplete#cancel_popup()
elseif has('nvim')
  Plug 'Shougo/deoplete.nvim'
  let g:deoplete#enable_at_startup=1
  let g:deoplete#auto_completion_start_length=1
  let g:deoplete#enable_smart_case=1
  let g:deoplete#enable_refresh_always=1
  let g:deoplete#text_mode_filetypes={ "pandoc": 1 }
  if !exists('g:deoplete#sources#omni#input_patterns')
      let g:deoplete#sources#omni#input_patterns={}
  endif
  if !exists('g:deoplete#sources')
      let g:deoplete#sources={}
  endif
  inoremap <expr><C-G> deoplete#undo_completion()
  inoremap <expr><C-L> deoplete#complete_common_string()
  inoremap <expr><C-H> deoplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-Y> deoplete#close_popup()
  inoremap <expr><C-E> deoplete#cancel_popup()
endif

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)

imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

Plug 'scrooloose/syntastic'
let g:syntastic_check_on_wq=0
let g:syntastic_check_on_open = 1
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_mode_map = {
  \'mode': 'passive',
  \'active_filetypes': [
      \'javascript',
      \'sh',
      \'elm',
      \'purescript',
      \'haskell',
      \'typescript'],
  \'passive_filetypes': []
  \}
nnoremap <silent> <leader>ss :SyntasticCheck<CR>
nnoremap <silent> <leader>sr :SyntasticReset<CR>

let g:syntastic_python_checkers     = ['pylint']
let g:syntastic_haskell_checkers    = ['hdevtools', 'hlint']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_typescript_checkers = ['tslint']
let g:syntastic_sh_checkers         = ['shellcheck']
let g:syntastic_purescript_checkers = ['pscide']
let g:syntastic_elm_checkers        = ['elm_make']

Plug 'dhruvasagar/vim-table-mode'
let g:table_mode_corner = '+'

Plug 'bronson/vim-visual-star-search'

Plug 'milkypostman/vim-togglelist'
nnoremap <script> <silent> <leader>l :call ToggleLocationList()<CR>
nnoremap <script> <silent> <leader>q :call ToggleQuickfixList()<CR>

Plug 'tyru/open-browser.vim'
let g:netrw_nogx = 1
nnoremap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

Plug 'dbakker/vim-projectroot', { 'on': ['ProjectRootExe', 'ProjectRootCD'] }
function! <SID>AutoProjectRootCD()
  try
    if &ft != 'help'
      ProjectRootCD
    endif
  catch
    " Silently ignore invalid buffers
  endtry
endfunction
augroup vimrc_project
  au!
  au BufEnter * call <SID>AutoProjectRootCD()
augroup END
nnoremap <leader>C :ProjectRootCD<cr>
nnoremap <silent> <leader>ft :ProjectRootExe VimFiler<cr>

if has('nvim')
  Plug 'Shougo/denite.nvim'
else
  Plug 'Shougo/unite.vim'
  Plug 'Shougo/unite-outline'
endif

let g:unite_source_history_yank_enable=1
nnoremap [unite] <Nop>
nmap <leader>u [unite]
nnoremap <silent> [unite]u :Unite
                    \ -profile-name=files
                    \ -buffer-name=git-files
                    \ file_rec/git:--cached:--others:--exclude-standard
                    \<cr>
nmap <C-P> <leader>uu

call plug#end()

" Unite.vim / Denite.vim {{{
augroup vimrc_unite
  au!
  au FileType unite call s:unite_my_settings()

  " do not use <C-P> in command window
  au CmdwinEnter * nnoremap <buffer> <C-P> <C-P>
  au CmdwinEnter * nnoremap <buffer> <C-P> <C-P>
augroup END

fu! s:unite_my_settings()
    imap <silent><buffer><expr> <C-v> unite#do_action('vsplitswitch')
endfu

call unite#custom#profile('files', 'context', {
  \ 'start_insert': 1,
  \ 'unique': 1,
  \ 'no_split': 1,
  \ 'no_empty': 1,
  \ 'resume': 0,
  \ })

call unite#custom#profile('files', 'sorters', [
  \ 'sorter_rank'
  \ ])

call unite#custom#profile('files', 'matchers', [
  \ 'matcher_default',
  \ 'matcher_fuzzy',
  \ 'matcher_hide_hidden_files'
  \ ])

call unite#custom#profile('files', 'converters', [
  \ 'converter_relative_abbr',
  \ 'converter_smart_path',
  \ ])
" }}}

" }}}
" Global preferences {{{
" ------------------------------------------------------------------------------
syn on
set foldlevelstart=20
set conceallevel=0
set mouse=
set history=10000
set noshowmatch
set undofile
set noshowmatch
set updatetime=500
set completeopt=longest,menuone,preview
set cmdheight=2
set splitbelow
set lazyredraw
set sessionoptions-=options
set sessionoptions-=folds
if has('nvim')
  set viminfo='50,<1000,s100,n~/.nviminfo
else
  set viminfo='50,<1000,s100,n~/.viminfo
endif
set autoindent
set backspace=indent,eol,start
set complete-=1
set showmatch
set smarttab
set nrformats-=octal
set shiftround
set ttimeout
set ttimeoutlen=100
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
augroup vimrc_qf
  au!
  au FileType qf wincmd J " quickfix list at bottom
augroup END
set wildignore=*.o,*.obj,*.bak,*.exe,*.pyc,*.swo,*.swp,*.swq,*.swr
set wildignore+=*.png,*.tga,*.psd,*.jpg,*.jpeg,*.svg
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
set synmaxcol=120
set cmdwinheight=1
set regexpengine=1
exec "set listchars=tab:\\|→"
exec "set list lcs+=trail:\uB7,nbsp:~"
" }}}
" Theme  {{{
" ------------------------------------------------------------------------------
set colorcolumn=+1

if has("gui_running")
  colo luna
  set guifont=Consolas:h12:cANSI
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
  " colo luna-term
  colo luna
  hi CursorLine term=NONE cterm=NONE ctermbg=236
endif
" }}}
" Filetypes {{{
" ------------------------------------------------------------------------------
fun! s:DetectHaskellScript()
    if getline(1) == '#!/usr/bin/env stack'
        set ft=haskell
    endif
endfun

augroup vimrc_filetypes
au!
  au BufNewFile,BufRead * call s:DetectHaskellScript()

  " Help vim recognize file types
  au BufRead,BufNewFile *.jsx           setl ft=javascript
  au BufRead,BufNewFile *.jsxinc        setl ft=javascript
  au BufRead,BufNewFile *.mxi           setl ft=xml
  au BufRead,BufNewFile *.cshtml        setl ft=xml.javascript
  au BufRead,BufNewFile *.ls            setl ft=ls
  au BufRead,BufNewFile *.as            setl ft=as3
  au BufRead,BufNewFile *.shader        setl ft=cg
  au BufRead,BufNewFile *.dart          setl ft=dart
  au BufRead,BufNewFile *.slim          setl ft=slim
  au BufRead,BufNewFile *.ts            setl ft=typescript
  au BufRead,BufNewFile *.md            setl ft=markdown
  au BufRead,BufNewFile *.mdown         setl ft=markdown
  au BufRead,BufNewFile *.markdown      setl ft=markdown
  au BufRead,BufNewFile *.jsx           setl ft=jsx
  au BufRead,BufNewFile *.json          setl ft=json
  au BufRead,BufNewFile *.json.template setl ft=json
  au BufRead,BufNewFile *.jade          setl ft=jade
  au BufRead,BufNewFile Dockerfile.*    setl ft=dockerfile
  au BufNewFile,BufRead *.shader        setl ft=glsl.c

  " fix foldmethod for neocomplete/deoplete
  " Refer: https://github.com/Shougo/deoplete.nvim/issues/27
  au BufEnter,BufRead,BufNewFile * setl fdm=marker

  " Configure indentation based on language
  au filetype html       setl shiftwidth=2
  au filetype typescript setl shiftwidth=2
  au filetype purescript setl shiftwidth=2
  au filetype ruby       setl shiftwidth=2
  au filetype javascript setl shiftwidth=2
  au filetype jade       setl shiftwidth=2
  au filetype vim        setl shiftwidth=2
  au filetype yaml       setl shiftwidth=2
  au filetype sh         setl shiftwidth=2
  au filetype json       setl shiftwidth=2

  " Configure Haskell
  au filetype haskell setl indentexpr=
  au filetype haskell setl tags=tags;/,codex.tags;/

  " Configure Typescript
  au filetype typescript setl indentexpr=
  au filetype typescript setl indentkeys=

  " Configure Shell
  au filetype sh setl noexpandtab
  au filetype sh setl shiftwidth=4

  " Configure Python
  au filetype python setlocal foldmethod=indent
  au filetype python nnoremap <buffer> <F7> :exe "w \| !python %"<CR>

  " Configure Purescript
  " Note: Ensure auto-comment insertion (does not work by default)
  au filetype purescript setl comments=sl:--,mb:--
  au filetype purescript iabbrev forall ∀
  au filetype purescript setl nowritebackup

  " Configure Elm
  " Note: Remove this once https://github.com/ElmCast/elm-vim/issues/114 is fixed
  au filetype elm setl shiftwidth=2
  au BufWritePre *.elm call elm#Format()
  au BufWritePost *.elm call elm#util#EchoStored()
augroup END

" }}}
" Goodies {{{
" ------------------------------------------------------------------------------

" Open a help in a vertsplit. Use with `:Vh`
command! -nargs=* -complete=help Vh vertical belowright help <args>

" Bind the last run command to a hotkey
" e.g.: :BindLast <F7>
func! BindCommand(key)
  let b:cmd  = histget('cmd', -2)
  let b:comp = ":w! \\| ".b:cmd
  exec ":nnoremap ".a:key." :exe \"".b:comp."\"<CR>"
endfunc
command! -nargs=+ BindLast :call BindCommand(<q-args>)

augroup vimrc_cmdwin
  au!
  " have <Ctrl-C> leave cmdline-window
  autocmd CmdwinEnter * nnoremap <buffer> <C-C> :q\|echo ""<CR>
  autocmd CmdwinEnter * nnoremap <buffer> <C-G> :q\|echo ""<CR>
  autocmd CmdwinEnter * inoremap <buffer> <C-G> <ESC>:q\|echo ""<CR>

  " start command line window in insert mode and no line numbers
  autocmd CmdwinEnter * set nonumber
  autocmd CmdwinEnter * set foldmethod=marker
augroup END

" Working directory per tab
augroup vimrc_tabs
  au!
  au TabEnter * if exists("t:wd") | exe "cd " . fnameescape(t:wd) | endif
  au TabLeave * let t:wd=getcwd()
augroup END

" Working with the fugitive commit buffer
func! SetFugitiveTextWidth()
  if (line('.') == 1)
    setl tw=50
  else
    setl tw=72
  endif
endfunc

augroup vimrc_fugitive
  au!
  au BufEnter     *COMMIT_EDITMSG setl spell
  au CursorMoved  *COMMIT_EDITMSG call SetFugitiveTextWidth()
  au CursorMovedI *COMMIT_EDITMSG call SetFugitiveTextWidth()
  au BufEnter     *COMMIT_EDITMSG call SetFugitiveTextWidth()
augroup END

augroup quickfix
    au!
    " Enable line-wrapping in the quickfix list:
    au FileType qf setlocal wrap
    " Close vim if quickfix window is last window:
    au WinEnter * if winnr('$') == 1 && getbufvar(winbufnr(winnr()), "&buftype") == "quickfix"|q|endif
augroup END

" }}}
