" GENERAL SETTINGS
color desert
syntax on
filetype plugin indent on
set ts=4 sts=4 sw=4 et
set hlsearch
set nu
set backspace=indent,eol,start
set formatoptions-=cro

" MAPS (NON-PLUGIN)
map <silent> <C-h> :noh<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>//gc<left><left><left>
nnoremap <C-l> :tabmove +1<CR>
nnoremap <C-h> :tabmove -1<CR>
imap jj <Esc>

" MACROS
let @p='"_diwP'

" ALIASES
command GGT GitGutterSignsToggle

" VIM-PLUG SETUP
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
silent !mkdir -p ~/.vim/plugs

" PLUGINS
call plug#begin('~/.vim/plugs')
Plug 'tpope/vim-commentary'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'gcmt/taboo.vim'
Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
Plug 'dhruvasagar/vim-table-mode'
Plug 'tpope/vim-surround'
call plug#end()

" MAPS (PLUGINS)
let g:ctrlp_map = '<leader>o'
nnoremap <leader>tr :TabooRename<space>
