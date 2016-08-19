
" =============== FILETYPE ===============
filetype on
filetype plugin on    
filetype indent on    

" =============== SETTINGS ===============
" VIM
syntax on
set term=screen-256color
set noshowmode
set scrolloff=10
set wildmenu
set smartindent
set autoindent
set backspace=indent,eol,start
set number
set cursorline
set expandtab
set shiftwidth=2
set softtabstop=2
set relativenumber
let mapleader = ","

" AIRLINE
set laststatus=2
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='molokai'
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_section_c = airline#section#create_left(['','%t'])
let g:airline_section_z = airline#section#create(['%{strftime("%c")}'])
let g:airline_section_y = airline#section#create_right(['%l','%c'])

" NERDTree
map <Leader>n <plug>NERDTreeTabsToggle<CR>
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1


" =============== COLORS   ===============
set background=dark
colorscheme solarized

" =============== COMMANDS ===============
" PHP {{{
augroup php_settings
  autocmd!
  autocmd BufRead,BufWritePre *.php setfiletype php
  autocmd BufRead,BufNewFile *.php setfiletype php
  autocmd Filetype php nnoremap <buffer> <leader>c I/* <esc>A */
  autocmd FileType php inoremap <buffer> <C-p> <ESC>:call PhpDocSingle()<CR>i
  autocmd FileType php nnoremap <buffer> <C-p> :call PhpDocSingle()<CR>
  autocmd FileType php vnoremap <buffer> <C-p> :call PhpDocRange()<CR> 
augroup END
" }}}

" Fold {{{
augroup fold_saving
  autocmd BufWinLeave ?* mkview 1
  autocmd BufWinEnter ?* silent loadview 1
augroup END
" }}}

" =============== MAPPINGS ===============
" Insert Mappings
imap <leader>' ''<ESC>i
imap <leader>" ""<ESC>i
imap <leader>( ()<ESC>i
imap <leader>[ []<ESC>i
imap <leader>{ {}<ESC>i
imap jj <ESC>
imap <c-s> <ESC>:w<CR>a

" Normal Mappings
nmap e :e<Space>
nmap <leader>ev :vsplit $MYVIMRC<CR>
nmap <leader>rs :so $MYVIMRC<CR>
nmap <leader>elf :vsplit ~/.vim/laravel/function.vim<CR>
nmap <leader>m :vsplit ~/.vim/startup/package.vim<CR>
nmap <leader>tn :tabnew<Space>
nmap W :w<CR>
nmap K :q<CR>
nmap <Space> za
