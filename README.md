# Dotfiles
dotfiles

## Usage
To install, run the following in the root of this repo:
```bash
stow -t ~ .
```

To uninstall, run the following in the root of this repo:
```bash
stow -t ~ -D .
```

## Configure formatter per-project
To configure `:Autoformat` per-project (i.e., per-directory) create a `.vimrc` file in the root of the project with the following content:
```vim
let g:formatdef_cpp_example = '"example command"'
let g:formatters_cpp = ["cpp_example"]
```
You can check filetype for the current file with `:set ft?` in vim. For git repos you can ignore the local `.vimrc` by adding it to `.git/info/exclude`.
