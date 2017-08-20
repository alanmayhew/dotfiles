color desert
syntax on
filetype plugin indent on
set ts=4 sts=4 sw=4 et
set hlsearch
set nu
set backspace=indent,eol,start

map <silent> <C-h> :noh<CR>
nnoremap <leader>s :%s/\<<C-r><C-w>\>//gc<left><left><left>
imap jj <Esc>

let @p='"_diwP'
