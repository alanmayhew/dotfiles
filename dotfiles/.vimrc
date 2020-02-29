"===============================================================================
"                              GENERAL SETTINGS
"===============================================================================
silent! colorscheme desert
syntax on
filetype plugin indent on
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set hlsearch
set number
set backspace=indent,eol,start
set formatoptions=tq
set updatetime=500
set colorcolumn=80
if has('gui_running')
    set mouse=v
    if has("win32")
        set guioptions-=r guioptions-=L
    endif
endif

" Set cursor (odd/even => blinking/solid, 1/2=block, 3/4=under, 5/6=vert)
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

if exists('+termguicolors')
    if &term =~ '256color'
        " Disable Background Color Erase (BCE)
        set t_ut=
    endif
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
 endif

"===============================================================================
"                               VIM-PLUG SETUP
"===============================================================================
if has("win32")
    " WINDOWS
    if glob("$VIM/_vimrc")
        echom "\n\nMake sure you delete the default _vimrc at '".$VIM."/_vimrc'"
    endif
    if empty(glob("~/vimfiles/autoload/plug.vim"))
        silent !mkdir "\%userprofile\%\\vimfiles\\autoload"
        silent !mkdir "\%userprofile\%\\vimfiles\\plugs"
        silent !bitsadmin /transfer vimplug /download /priority normal https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \%userprofile\%\\vimfiles\\autoload\\plug.vim
        if system("git status") =~ "internal or external command"
            echom "\n\nGit isn't installed, so everything plugin related is gonna break\n\n"
        endif
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
else
    " LINUX / OTHER
    if empty(glob("~/.vim/autoload/plug.vim"))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    silent !mkdir -p ~/.vim/plugs
endif

"===============================================================================
"                                  PLUGINS
"===============================================================================
if has("win32")
    call plug#begin('~/vimfiles/plugs')
else
    call plug#begin('~/.vim/plugs')
endif

" General / useful things
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
" Plug 'mhinz/vim-signify'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-speeddating'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'gcmt/taboo.vim'
Plug 'easymotion/vim-easymotion'
Plug 'dhruvasagar/vim-table-mode'
Plug 'yggdroot/indentline'
Plug 'ludovicchabant/vim-gutentags'

" Language specific
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'nvie/vim-flake8'

" Misc
Plug 'junegunn/vim-emoji'

" Color schemes
Plug 'nanotech/jellybeans.vim'
Plug 'zeis/vim-kolor'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
call plug#end()


"===============================================================================
"                             MAPS (NON-PLUGIN)
"===============================================================================
"........................................................................ TABS
nnoremap <silent> L :tabnext<CR>
nnoremap <silent> H :tabprevious<CR>
nnoremap <silent> [t :tabmove -1<CR>
nnoremap <silent> ]t :tabmove +1<CR>
nnoremap <silent> <C-t> :tabnew<CR>
"............................................................. SEARCH / REPLACE
noremap <silent> <C-h> :noh<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>//gc<left><left><left>
".................................................................. INSERT MODE
inoremap jj <Esc>
inoremap jk <Esc>
"................................................................ SETTINGS / UI
nnoremap <leader>vs :source $MYVIMRC<CR>
nnoremap <leader>ve :tabnew $MYVIMRC<CR>
nnoremap <leader>rn :call ToggleRNU()<CR>
"......................................................................... TAGS
nnoremap <C-o> <C-w>}
nnoremap <C-i> <C-w>z
"......................................................................... MISC
if exists(":Commentary")
    " co                Comments the current line and puts an uncommented copy
    "                   below it (relies on vim-commentary plugin; if it's not
    "                   present, the mapping will instead yank and paste above
    "                   the current line for easy manual commenting)
    nmap co yygccp
else
    nmap co yyP
endif
nnoremap <silent> cp :set opfunc=ReplaceWithYanked<CR>g@
    " cp{motion}        Replace the text that {motion} moves over with the text
    "                   from the " register
vnoremap <silent> cp :<C-U>call ReplaceWithYanked(visualmode(), 1)<CR>
    " {Visual}cp        Replaces the highlighted text with the text from the "
    "                   register
vnoremap <leader>q :normal @q<CR>
vnoremap <leader>d :g/^\s*$/d<CR>:noh<CR>

"===============================================================================
"                               MAPS (PLUGINS)
"===============================================================================
map <Space> <Plug>(easymotion-prefix)
nnoremap <leader>tr :TabooRename<space>
nnoremap <leader>tm :TableModeToggle

"===============================================================================
"                                  COMMANDS
"===============================================================================
command! GGT GitGutterSignsToggle
command! Hex %!xxd
command! Unhex %!xxd -r

"===============================================================================
"                                 FUNCTIONS
"===============================================================================
" toggle relative line numbers autocmd (when relativenumber is set, only keep
" it set in the buffer with focus, and disable it in insert mode)
function! ToggleRNU()
    set invrelativenumber
    if &rnu
        augroup numbertoggle
            autocmd!
            autocmd BufEnter,FocusGained,InsertLeave * set rnu
            autocmd BufLeave,FocusLost,InsertEnter * set nornu
        augroup END
    else
        augroup numbertoggle
            autocmd!
        augroup END
    endif
endfunction

" replace an area from a visual selection or motion with what's in the "
" register (used with the cp{motion} mapping)
function! ReplaceWithYanked(type, ...)
    if a:0
        silent exe "normal! gv"
    elseif a:type == "line"
        silent exe "normal! '[V']"
    else
        silent exe "normal! `[v`]"
    endif
    silent exe "normal! ".'"'."_c\<C-R>".'"'."\<Esc>"
endfunction

"===============================================================================
"                                COLOR SCHEME
"===============================================================================
let g:jellybeans_use_gui_italics = 0
let g:gruvbox_italic = 0
silent! colorscheme gruvbox

"===============================================================================
"                             OPTIONS (PLUGINS)
"===============================================================================
let g:ctrlp_user_command = {
\     'types': {
\         1: ['.git', 'cd %s && git ls-files -co --exclude-standard'],
\         2: ['.hg', 'cd %s && hg status --quiet --no-status --all --clean --unknown'],
\     },
\     'fallback': 'find %s -type f'
\ }

let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='
