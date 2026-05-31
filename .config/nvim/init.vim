source ~/.vimrc

" different directories for swap, backup, and undo
if !isdirectory(expand('~/.nvim/swapfiles'))
  silent !mkdir -p ~/.nvim/swapfiles
endif
if !isdirectory(expand('~/.nvim/backupfiles'))
  silent !mkdir -p ~/.nvim/backupfiles
endif
if !isdirectory(expand('~/.nvim/undo'))
  silent !mkdir -p ~/.nvim/undo
endif

set directory=~/.nvim/swapfiles//
set backupdir=~/.nvim/backupfiles//
set undodir=~/.nvim/undo//

set nohlsearch " don't highlight search results

