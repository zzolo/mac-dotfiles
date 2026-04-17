#! /bin/sh

# Install scripts.  Note that this could technically be run, but
# it is unlikely to actually work, so it is more meant to be a
# reference to copy-paste from.
#####

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Updating homebrew packages..."
brew update --force

# General packages without arguments
PACKAGES=(
  # Linux utilities
  coreutils
  gnu-sed
  gnu-tar
  gnu-indent
  gnu-which
  grep
  findutils

  # General
  1password-cli
  ffmpeg
  jq
  vim
  wget
  sqlite
  gpg

  # Git
  git
  hub
  gh

  # Coding
  fnm

  # Shell/prompt
  stow
  starship

  # Fonts
  # https://www.nerdfonts.com/font-downloads
  # brew install --cask font-<FONT NAME>-nerd-font
  font-hack-nerd-font
)

echo "Installing homebrew packages..."
brew install ${PACKAGES[@]}

echo "Cleaning homebrew up..."
brew cleanup

echo "Mac configuration..."
# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Turn off drop shadow on screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Show hidden apps
defaults write com.apple.Dock showhidden -bool true

# Allow to copy text in Quick lock
defaults write com.apple.finder QLEnableTextSelection -bool true

# Expand print and save dialogs by default
defaults write -g PMPrintingExpandedStateForPrint -bool true
defaults write -g NSNavPanelExpandedStateForSaveMode -bool true

# Default screenshot location away from Desktop
mkdir -p ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots

# Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Get custom plugins for Oh My Zsh
echo "Installing custom plugins for Oh My Zsh"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# UV
echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Python packages
echo "Installing global Python packages..."
uv tool install "beets[discogs,fetchart,lastgenre,embedart]"
uv tool install csvkit

# Keybase
echo "Installing Keybase (and keys)..."
if type "keybase" > /dev/null; then
  export GPG_TTY=$(tty)
    keybase pgp pull && \
    keybase pgp export | gpg --import && \
    keybase pgp export -s | gpg --allow-secret-key-import --import && \
    echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
else
  echo "Keybase cli not installed; please install it."
fi

# VS Code extensions
echo "Installing VS Code extensions..."
if type "code" > /dev/null; then
  # Python
  code --install-extension ms-python.python
  code --install-extension ms-python.vscode-pylance
  code --install-extension njpwerner.autodocstring
  code --install-extension charliermarsh.ruff
  code --install-extension ms-toolsai.jupyter
  code --install-extension tamasfe.even-better-toml

  # JS
  code --install-extension rvest.vs-code-prettier-eslint
  code --install-extension dbaeumer.vscode-eslint
  code --install-extension svelte.svelte-vscode

  # Github
  code --install-extension GitHub.copilot
  code --install-extension github.vscode-github-actions

  # Other
  code --install-extension EditorConfig.EditorConfig
  code --install-extension esbenp.prettier-vscode
  code --install-extension johnpapa.vscode-peacock
  code --install-extension mechatroner.rainbow-csv
  code --install-extension ms-azuretools.vscode-docker
  code --install-extension redhat.vscode-yaml
  code --install-extension streetsidesoftware.code-spell-checker
else
  echo "VS Code cli not installed; please install it."
fi
