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
vnoremap <leader>q :normal @q<CR>
vnoremap <leader>d :g/^\s*$/d<CR>:noh<CR>

"===============================================================================
"                               MAPS (PLUGINS)
"===============================================================================
map <Space> <Plug>(easymotion-prefix)
nnoremap <leader>tr :TabooRename<space>
nnoremap <leader>tm :TableModeToggle
nnoremap <leader>ig :IndentLinesToggle<CR>
" Git
nnoremap <leader>gb :Gblame<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>gg :Git grep -n --color=ALWAYS<Space>

"===============================================================================
"                                  COMMANDS
"===============================================================================
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

" Execute a command string on a block of text from a motion or visual
" selection (doesn't use 'silent!' just in case errors matter)
function! s:ExecOnBlock(cmd_str, type, ...)
    if a:0
        silent exe "normal! gv"
    elseif a:type == "line"
        silent exe "normal! '[V']"
    else
        silent exe "normal! `[v`]"
    endif
    silent exe a:cmd_str
endfunction

" Used in conjunction with a function that calls s:ExecOnBindBlock, to bind it
" to the same binding in visual and normal mode such that it will be called
" properly
function! s:BindBlockFunction(binding, funcname)
    let l:normal_bind_cmd =
            \ printf(
                \ "nnoremap <silent> %s :set opfunc=%s<CR>g@",
                \ a:binding, a:funcname
            \ )
    let l:visual_bind_cmd =
            \ printf(
                \ "vnoremap <silent> %s :<C-U> call %s(visualmode(), 1)<CR>",
                \ a:binding, a:funcname
            \ )
    silent exe l:normal_bind_cmd
    silent exe l:visual_bind_cmd
endfunction

" Replaces text in a motion or visual selection with what's currently in the
" unnamed register, without changing the value in the register
let s:replace_with_yank = "normal! ".'"'."_c\<C-R>".'"'."\<Esc>"
function! ReplaceWithYanked(type, ...)
    call function("s:ExecOnBlock", [s:replace_with_yank, a:type] + a:000)()
endfunction
call s:BindBlockFunction("cp", "ReplaceWithYanked")

" Converts text in camelCase to be lowercase_with_underscores
let s:camel_to_lower_cmd =
            \ "normal! :s/\\%V\\(\\w\\)\\([A-Z]\\)/".
            \ "\\1_\\l\\2/g\<CR>"
function! CamelToLower(type, ...)
    silent! call function("s:ExecOnBlock", [s:camel_to_lower_cmd, a:type] + a:000)()
endfunction
call s:BindBlockFunction("<leader>c", "CamelToLower")

" Converts text to sPoNgEbOb MoCkInG cAsE
let s:spongecase_cmd =
        \ "normal! :s/\\%V\\([a-z]\\)\\([^a-z]*\\)\\([a-z]\\)\\c/"
        \ ."\\l\\1\\2\\u\\3/g\<CR>"
function! SpongeCase(type, ...)
    silent! call function("s:ExecOnBlock", [s:spongecase_cmd, a:type] + a:000)()
endfunction
call s:BindBlockFunction("<leader>m", "SpongeCase")


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
