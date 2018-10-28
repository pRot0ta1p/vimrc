call plug#begin('C:\\Program Files\ (x86)\\Vim\\plugged')

Plug 'lervag/vimtex'
Plug 'w0rp/ale'
Plug 'Valloric/YouCompleteMe'
Plug 'vim-pandoc/vim-pandoc-syntax' 
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'altercation/vim-colors-solarized'
call plug#end()

set history=1000
filetype plugin on
filetype indent on
syntax enable
set ai

set autoread
set guifont=Fira_Code_Retina:h16:cANSI:qDRAFT
set wildmenu
set ruler
set nocompatible
set backspace=eol,start,indent
set whichwrap+=<,>,h,l
set ignorecase
set smartcase
set hlsearch
set incsearch
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set lazyredraw 
set magic
set showmatch 
set mat=2
set ffs=unix,dos,mac
set expandtab
set smarttab
set shiftwidth=4
set si 
set wrap 
set tabstop=4
set path+=**
set runtimepath+=D:/vimplugins/YouCompleteMe
set clipboard+=unnamed
set background=dark
colorscheme Solarized
set so=5
set relativenumber
set cmdheight=1
set hid
set shortmess+=I
set encoding=utf8
set ffs=unix,dos,mac
set splitbelow
set splitright

if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set guioptions-=m
    set guioptions-=t
    set guioptions-=r
    set guioptions-=R
    set guioptions-=L
    set guioptions-=b
    set guioptions-=l
    set t_Co=256
    set guitablabel=%M\ %t
endif

"silent function! Fixpath()
"        let b:fixpath="'" . escape(expand('%:p'), ' \') . "'"
"endfunction

"function! CompileRmd()
"    execute '! Rscript -e "library(rmarkdown);render("'.expand('%:p').'")"'
"endfunction

let mapleader = ","
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
map <silent> <leader><cr> :noh<cr>
autocmd Filetype rmd nnoremap  <leader>cp :execute 'silent !Rscript -e "library(rmarkdown);rmarkdown::render("' . "'" . escape(expand('%:p'), ' \') . "'" . '", encoding = ' . "'" . 'UTF-8' ."'" .')"'<CR>
autocmd Filetype pandoc.markdown nnoremap <leader>cp :execute 'silent !Rscript -e "library(rmarkdown);render("' . "'" . escape(expand('%:p'), ' \') . "'" . '", encoding = ' . "'" . 'UTF-8' ."'" .')"'<CR>

autocmd Filetype tex nnoremap <leader>cp <plug>(vimtex_compile)
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l
noremap <leader>bc :Bclose<cr>:tabclose<cr>gT
noremap <leader>bca :bufdo bd<cr>
noremap <leader>l :bnext<cr>
noremap <leader>h :bprevious<cr>
noremap <leader>te :tabedit <c-r>=expand("%:p:h")<cr>/
noremap <leader>tn :tabnew<cr>
noremap <leader>to :tabonly<cr>
noremap <leader>tc :tabclose<cr>
noremap <leader>tm :tabmove<cr>
noremap <leader>t<leader> :tabnext<cr>
let g:lasttab = 1
nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()
noremap <leader>cd :cd %:p:h<cr>:pwd<cr>
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
map 0 ^
inoremap jk <Esc>
inoremap kj <Esc>
nnoremap ; :
nnoremap o o<Esc>
nnoremap O O<Esc>
noremap <Leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm
map <leader>pp :setlocal paste!<cr>
nnoremap <silent> n n:call HLNext(0.1)<cr>
nnoremap <silent> N N:call HLNext(0.1)<cr>
cnoreabbrev rc $VIM/.vimrc
cnoreabbrev doc D:/Document

set laststatus=2
set statusline=[%l,%c]
set statusline+=\ %{HasPaste()}%f%m%r%h\ %w
set statusline+=%=
set statusline+=CWD:\ %{getcwd()}\ 
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]

set statusline+=\ %p%%

let g:python3_host_prog = 'D:/Python/'

augroup pandoc_syntax
        au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
augroup END

fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction 

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

function! HLNext (blinktime)
  let target_pat = '\c\%#'.@/
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

"vimtex setting
let g:vimtex_view_method = 'mupdf'
let g:vimtex_view_mupdf_send_keys = 1
let g:vimtex_complete_close_braces = 1
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-pdflatex="xelatex --shell-escape %O %S"',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ]
    \}

augroup vimtex_event_1
  au!
  au User VimtexEventQuit     call vimtex#compiler#clean(0)
augroup END


let g:UltiSnipsExpandTrigger = "<C-j>"
