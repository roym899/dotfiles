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

" create swap and backupfiles dir if it doesn't exist
if !isdirectory(expand('~/.vim/swapfiles'))
  silent !mkdir -p ~/.vim/swapfiles
endif
if !isdirectory(expand('~/.vim/backupfiles'))
  silent !mkdir -p ~/.vim/backupfiles
endif
if !isdirectory(expand('~/.vim/undo'))
  silent !mkdir -p ~/.vim/undo
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
Plug 'othree/html5.vim' " better HTML support
Plug 'unblevable/quick-scope' " highlighting for faster left/right navigation
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } } " for Ag search
Plug 'junegunn/fzf.vim'
Plug 'lambdalisue/fern.vim'
Plug 'djoshea/vim-autoread'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'lambdalisue/fern-hijack.vim'
Plug 'cespare/vim-toml'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'ggml-org/llama.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive' " git support
Plug 'lervag/vimtex'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'npm ci'}
Plug 'AndrewRadev/inline_edit.vim'

call plug#end()

syntax enable

set tabstop=4
set shiftwidth=4
set expandtab

" Create alias for vertical Git
cnoreabbrev git vert Git
cnoreabbrev Git vert Git

autocmd ColorScheme * highlight link QuickScopePrimary Define
autocmd ColorScheme * highlight link QuickScopeSecondary Function

" disable coc for multi cursor mode (autocomplete becomes very slow)
function! MyVmStart()
  execute 'CocDisable'
endfunction
function! MyVmExit()
  execute 'CocEnable'
endfunction
autocmd User visual_multi_start   call MyVmStart()
autocmd User visual_multi_exit    call MyVmExit()

" file ending to syntax
autocmd BufNewFile,BufRead *.cu set filetype=cpp
autocmd BufNewFile,BufRead *.cuh set filetype=cpp

" plugin specific options
let g:formatdef_multiple = '"isort - | black -q -"'
let g:formatters_python = ['multiple']
let g:formatters_cuda = ['clangformat']
let g:tex_flavor = 'latex'
let g:coc_disable_startup_warning = 1  " remove warning when using vim for git commit

set background=dark " otherwise colors for vim in tmux will be different
set termguicolors
colorscheme iceberg
highlight WinSeparator guifg=#2a3147 guibg=NONE

set directory=~/.vim/swapfiles//
set backupdir=~/.vim/backupfiles//
set undodir=~/.vim/undo//
set noswapfile " disable swap files

" Custom key bindings
inoremap qw <Esc>
vnoremap qw <Esc>

map Y y$

nnoremap V v$

nnoremap vv V

" moving up and down in wrapped lines
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')


" linenumbers
set number
" set relativenumber

" style
set fillchars+=vert:\│ " continuous, thin vertical split line

" C indent settings
" note that cindent is on by default for C/C++ files
set cinoptions+=(0,w1,W1s

" inline_edit settings
let g:inline_edit_autowrite = 1 " save to original file automatically
let g:inline_edit_new_buffer_command = "enew"

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

"Ctrl+P and Ctrl+Shift+P (similar to vscode)
nnoremap <silent> <C-p> :Files<CR>
inoremap <silent> <C-p> <C-o>:<C-u>Files<CR>
nnoremap <silent> <F12> :<C-u>CocCommand<CR>
inoremap <silent> <F12> <C-o>:<C-u>CocCommand<CR>

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

" make arrow keys behave like hjkl
nmap <buffer> <left> h
nmap <buffer> <up> k
nmap <buffer> <down> j
nmap <buffer> <right> l
nnoremap <Up> gk
nnoremap <Down> gj
nnoremap <Left> h
nnoremap <Right> l

" fern drawer by default
augroup my-fern-startup
  autocmd! *
  autocmd VimEnter * ++nested Fern . -drawer -stay -width=40
augroup END

" fern instead of netrw for explore commands
let loaded_netrwPlugin = 1 " disable netrw
nmap <leader>? <Plug>(fern-action-help) " remap ? to  backward search in vim
command! Explore Fern .
command! Vexplore vsplit | Fern .
command! Sexplore split | Fern .

" fern left right navigation (collapse and open)
autocmd FileType fern nnoremap <buffer> <Left> <Plug>(fern-action-collapse)
autocmd FileType fern nnoremap <buffer> <Right> <Plug>(fern-action-open-or-expand)

" llama.vim
let g:llama_config = { 'show_info': 0 } " disable info
let g:llama_config.keymap_fim_accept_full = "<S-Tab>"
let g:llama_config.keymap_fim_accept_line = "<S-Down>"
let g:llama_config.keymap_fim_accept_word = "<S-Right>"

" enable mouse
if !has("nvim")
  set ttymouse=xterm2
endif
set mouse=a
let g:VM_mouse_mappings = 1  " for visual-multi

" visual-multi key mappings
nnoremap <C-j> <Plug>(VM-Add-Cursor-Down)
nnoremap <C-k> <Plug>(VM-Add-Cursor-Up)

" disable C-w o to avoid accidentally destroying the workspace
noremap   <C-w>o <Nop>

" other options 
set splitright " open new vertical splits to the right
set splitbelow " open new horizontal splits to the bottom
set wildmode=longest,list " let tab behave like in bash
set tildeop " make tilde use motion instead of just count
set clipboard=unnamedplus
set updatetime=300 " crisp user experience
set timeoutlen=1000 " waiting for mappings
set ttimeoutlen=0 " faster keycodes
set scrolloff=5 " keep 5 lines above and below cursor
set undofile
set undolevels=1000
set undoreload=10000
set spell  " enable spell checking
set spellcapcheck=  " disable capitalization check
au FileType * setlocal formatoptions-=c formatoptions-=o formatoptions-=r
:set exrc " read local .vimrc
autocmd BufEnter * :syntax sync fromstart " slow but improved syntax highlighting
map <S-k> <Nop> " remove K (look up doc)

nnoremap gb <C-O> " remap C-O to gb (go back) to avoid splitting conflict

" hi! ErrorMsg ctermfg=red ctermbg=White cterm=underline
hi! VM_Mono ctermfg=red cterm=underline
hi default link VM_Cursor Visual
hi default link VM_Extend PmenuSel
hi default link VM_Insert DiffChange

" Large file handling
function! HandleLargeFile()
  " Set your limits: 10MB or 200,000 lines. Adjust as needed.
  let s:file_size_limit = 10000000
  let s:line_count_limit = 200000

  if getfsize(expand('%:p')) > s:file_size_limit || line('$') > s:line_count_limit
    echo "Large file detected. Disabling coc..."

    " Disable CoC (if you have it)
    if exists(':CocDisable')
      CocDisable
    endif
  endif
endfunction

augroup LargeFile
  " Clear any old autocommands in this group
  autocmd!
  " Call our function every time a file is opened
  autocmd BufReadPost * call HandleLargeFile()
augroup END


" Osc52 yank
augroup Osc52Yank
    autocmd!
    autocmd TextYankPost * call s:Osc52Copy()
augroup END

function! s:Osc52Copy()
    if v:event.regname ==# '' || v:event.regname ==# '+' || v:event.regname ==# '*'
        let l:payload = join(v:event.regcontents, "\n")
        if v:event.regtype ==# 'V'
            let l:payload .= "\n"
        endif

        " Encode to Base64 using the system tool
        let l:b64 = system("base64 | tr -d '\n'", l:payload)

        " Construct the OSC 52 sequence
        " \e]52;c; is the start, \x07 (BEL) is the terminator
        let l:osc = "\e]52;c;" . l:b64 . "\x07"

        " Tmux wrapper logic
        if $TMUX !=# ''
            let l:osc = "\ePtmux;\e" . substitute(l:osc, "\e", "\e\e", "g") . "\e\\"
        endif

        " Use echoraw if available (Vim 8.2.0892+)
        if exists('*echoraw')
            call echoraw(l:osc)
        else
            " Fallback: Write directly to the terminal via a silent execute
            " This 'set t_XR=' trick forces Vim to output the string to the tty
            let l:old_tty = &t_ti
            let &t_ti = l:osc
            silent! set t_ti=
            let &t_ti = l:old_tty
        endif
    endif
endfunction
