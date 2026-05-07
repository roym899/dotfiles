# Dotfiles
dotfiles

## Usage
To install, run the following in the root of this repo:
```bash
stow -t ~ .  # for macOS
stow -t ~ . --ignore=plist  # for Linux
```

To uninstall, run the following in the root of this repo:
```bash
stow -t ~ -D .
```
