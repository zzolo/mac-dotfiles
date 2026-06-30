# Dotfiles for Mac

## User files

- `.zshenv` - For all shells, interactive and non-interactive. This should contain PATH and other environment variables that need to be set for all shells. Specifically note that something like Claude, sub processes, or scripts will not have access to other files, so tools that should be accessible to those things can go in here. Avoid anything sensitive in this file.
- `.zprofile` - For login shells, such as terminal or ssh. Generally not needed given the use of `.zshenv`.
- `.zshrc` - For interactive shells. Generally reserved for Oh My Zsh settings and plugins.
  - `.zshrc-extended` - Anything specific to interactive shells that is not related to Oh My Zsh. This file is sourced from `.zshrc`.
  - `.zshrc-user` - For sensitive user-specific settings that won't get committed to this repo. This file is sourced from `.zshrc`.

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

## Manual setup

1. 1Password git signing
   - https://developer.1password.com/docs/ssh/git-commit-signing/
