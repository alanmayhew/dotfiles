" GENERAL SETTINGS
color desert
syntax on
filetype plugin indent on
set ts=4 sts=4 sw=4 et
set hlsearch
set nu
set backspace=indent,eol,start
set formatoptions-=cro
set updatetime=500
if has('gui_running')
    set mouse=v
    if has("win32")
        set guioptions-=r guioptions-=L
    endif
endif

" MAPS (NON-PLUGIN)
map <silent> <C-h> :noh<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>//gc<left><left><left>
nnoremap <silent> L :tabmove +1<CR>
nnoremap <silent> H :tabmove -1<CR>
nnoremap <silent> <leader>n :tabnew<CR>
imap jj <Esc>
nmap <Space> <leader><leader>
vmap <Space> <leader><leader>
nmap co yygccp
nmap cp "_ciw<C-r>"<Esc>

" ALIASES
command GGT GitGutterSignsToggle
command Hex %!xxd
command Unhex %!xxd -r

" VIM-PLUG SETUP
if has("win32")
    " WINDOWS
    if glob("$VIM/_vimrc")
        echo "\n\nMake sure you delete the default _vimrc at '" . $VIM . "/_vimrc'"
    endif
    if empty(glob("~/vimfiles/autoload/plug.vim"))
        silent !mkdir "\%userprofile\%\\vimfiles\\autoload"
        silent !mkdir "\%userprofile\%\\vimfiles\\plugs"
        silent !bitsadmin /transfer vimplug /download /priority normal https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \%userprofile\%\\vimfiles\\autoload\\plug.vim
        if system("git status") =~ "internal or external command"
            echo "\n\nGit isn't installed, so everything plugin related is gonna break\n\n"
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

" PLUGINS
if has("win32")
    call plug#begin('~/vimfiles/plugs')
else
    call plug#begin('~/.vim/plugs')
endif
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-speeddating'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'gcmt/taboo.vim'
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'dhruvasagar/vim-table-mode'
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript'
Plug 'junegunn/vim-emoji'
call plug#end()

" MAPS (PLUGINS)
nnoremap <leader>tr :TabooRename<space>

" OPTIONS (PLUGINS)
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='
