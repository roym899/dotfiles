set nocompatible " should be default, but had a case where that wasn't the case

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Coc extensions
" let g:coc_global_extensions = ['coc-pyright']

call plug#begin('~/.vim/plugged')

Plug 'cocopon/iceberg.vim' " color scheme
Plug 'tpope/vim-sensible' " some better default settings
Plug 'tpope/vim-commentary' " add gcc and gc commands to toggle comments
Plug 'tpope/vim-eunuch' " add gcc and gc commands to toggle comments
Plug 'ConradIrwin/vim-bracketed-paste' " automatic paste / nopaste for pasting from clipboard
Plug 'Vimjas/vim-python-pep8-indent' " better indentation in Python
Plug 'bfrg/vim-cpp-modern' " better support for C++11/14/17/20
Plug 'tpope/vim-sleuth' " automatic indent adjustment based on file
Plug 'jvirtanen/vim-octave' " octave support
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Intellisense
" Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}  " PyRight
Plug 'Chiel92/vim-autoformat' " add :Autoformat to invoke autoformatter
Plug 'othree/html5.vim' " better HTML support
" Plug 'lervag/vimtex' " better support for tex
Plug 'udalov/kotlin-vim' " support for kotlin
Plug 'unblevable/quick-scope' " highlighting for faster left/right navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " for Ag search
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
" Plug 'lambdalisue/fern-hijack.vim'
" Plug 'github/copilot.vim'

call plug#end()

set tabstop=4
set shiftwidth=4
set expandtab


autocmd ColorScheme * highlight link QuickScopePrimary Define
autocmd ColorScheme * highlight link QuickScopeSecondary Function
colorscheme iceberg


" file ending to syntax
autocmd BufNewFile,BufRead *.cu set filetype=cpp
autocmd BufNewFile,BufRead *.cuh set filetype=cpp

" plugin specific options
let g:formatdef_multiple = '"isort - | black -q -"'
let g:formatters_python = ['multiple']
let g:formatters_cuda = ['clangformat']
let g:tex_flavor = 'latex'

set background=dark " otherwise colors for vim in tmux will be different
set directory=~/.vim/swapfiles// " must exist
set backupdir=~/.vim/backupfiles// " must exist
" set noswapfile " disable swap files

" Custom key bindings
inoremap jk <Esc>
map Y y$
" moving up and down in wrapped lines
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')

" linenumbers
set number
" set relativenumber

" style
set fillchars+=vert:\│ " continuous, thin vertical split line
hi VertSplit term=NONE cterm=NONE gui=NONE

" C indent settings
" note that cindent is on by default for C/C++ files
set cinoptions+=(0,w1,W1s

" Coc.nvim
" Tab completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"GoTo code navi
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
" Go to issues
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" scrolling of float windows
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
" Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif
nmap <leader>rn <Plug>(coc-rename)

" hjkl navigation in insert and command mode
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>
vnoremap <C-h> <Left>
vnoremap <C-j> <Down>
vnoremap <C-k> <Up>
vnoremap <C-l> <Right>

" make window navigation wrap aroun
function! s:GotoNextWindow( direction, count )
  let l:prevWinNr = winnr()
  execute a:count . 'wincmd' a:direction
  return winnr() != l:prevWinNr
endfunction

function! s:JumpWithWrap( direction, opposite )
  if ! s:GotoNextWindow(a:direction, v:count1)
    call s:GotoNextWindow(a:opposite, 999)
  endif
endfunction

nnoremap <silent> <C-w>h :<C-u>call <SID>JumpWithWrap('h', 'l')<CR>
nnoremap <silent> <C-w>j :<C-u>call <SID>JumpWithWrap('j', 'k')<CR>
nnoremap <silent> <C-w>k :<C-u>call <SID>JumpWithWrap('k', 'j')<CR>
nnoremap <silent> <C-w>l :<C-u>call <SID>JumpWithWrap('l', 'h')<CR>
nnoremap <silent> <C-w><Left> :<C-u>call <SID>JumpWithWrap('h', 'l')<CR>
nnoremap <silent> <C-w><Down> :<C-u>call <SID>JumpWithWrap('j', 'k')<CR>
nnoremap <silent> <C-w><Up> :<C-u>call <SID>JumpWithWrap('k', 'j')<CR>
nnoremap <silent> <C-w><Right> :<C-u>call <SID>JumpWithWrap('l', 'h')<CR>

" fern drawer by default
augroup my-fern-startup
  autocmd! *
  autocmd VimEnter * ++nested Fern . -drawer -stay
augroup END

" fern instead of netrw for explore commands
let loaded_netrwPlugin = 1 " disable netrw
nmap <leader>? <Plug>(fern-action-help) " remap ? to enable backward search in vim
command! Explore Fern .
command! Vexplore vsplit | Fern .
command! Sexplore split | Fern .

" other options
set splitright " open new vertical splits to the right
set splitbelow " open new horizontal splits to the bottom
set wildmode=longest,list " let tab behave like in bash
set tildeop " make tilde use motion instead of just count
set clipboard=unnamedplus
set updatetime=300 " crisp user experience
autocmd BufEnter * :syntax sync fromstart " slow but improved syntax highlighting
map <S-k> <Nop> " remove K (look up doc)
nnoremap gb <C-O> " remap C-O to gb (go back) to avoid splitting conflict
