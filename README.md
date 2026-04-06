# Dotfiles for Mac

## System setup

Probably want to copy and paste from here, but in theory could run: `setup.sh`

## Sensitive templates

```sh
cp .gitconfig-example .gitconfig
```

## Link up dotfiles

Dry run to see what will happen: `stow -nv -t ~ ./`

Run:

```sh
rm ~/.gitconfig
rm ~/.zprofile
rm ~/.zshrc
stow -v -t ~ ./
```