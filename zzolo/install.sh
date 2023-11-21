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
export PATH="/usr/local/sbin:$PATH";

# Core linux utilities
echo "Installing core homebrew packages..."
brew install coreutils
brew install gnu-sed
brew install gnu-tar
brew install gnu-indent
brew install gnu-which
brew install grep

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# General packages without arguments
PACKAGES=(
  ack
  autoconf
  automake
  ffmpeg
  git
  hub
  imagemagick
  jq
  libjpeg
  node
  pkg-config
  pyenv
  terminal-notifier
  tree
  vim
  wget
  composer
  mdbtools
  mysql
  gcc
  openssl
  yarn
  sqlite
  gpg
  pinentry-mac
)

echo "Installing homebrew packages..."
brew install ${PACKAGES[@]}

# Link up Python 3
brew link --overwrite python

# Heroku
brew tap heroku/brew && brew install heroku

# Terraform
brew tap hashicorp/tap && brew install hashicorp/tap/terraform

# Gcloud

# Instal RCM for linking dotfiles
echo "Installing RCM (https://github.com/thoughtbot/rcm)..."
brew tap thoughtbot/formulae
brew install rcm

# Instal homebrew cask font (svn, seriously?)
echo "Installing cask-fonts and fonts..."
brew install svn
brew tap homebrew/cask-fonts
brew install \
  font-anonymous-pro \
  font-dejavu-sans-mono-for-powerline \
  font-droid-sans-mono-for-powerline \
  font-meslo-lg \
  font-meslo-for-powerline \
  font-source-code-pro \
  font-source-code-pro-for-powerline \
  font-source-sans-pro \
  font-fontawesome \
  font-awesome-terminal-fonts

echo "Cleaning homebrew up..."
brew cleanup

# Custom LS_COLORS
curl "https://raw.githubusercontent.com/trapd00r/LS_COLORS/master/LS_COLORS" > ~/.dircolors

echo "Installing global npm packages..."
NPM_PACKAGES=(
  eslint
  trash-cli
)
npm install -g ${NPM_PACKAGES[@]}

echo "Install NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

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
mkdir -p ~/Pictures/Screenshots
defaults write com.apple.screencapture location ~/Pictures/Screenshots

# Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Get custom plugins for Oh My Zsh
echo "Installing custom plugins for Oh My Zsh"
git clone https://github.com/bhilburn/powerlevel9k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}themes/powerlevel9k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# The p10k config is everything, so not worth having our own
echo "Suggested to configure Powerline 10k with: p10k configure"

# Python packages
echo "Installing global Python packages..."
pip install -U csvkit
# Beets and plugins
pip install -U git+https://github.com/beetbox/beets@master#egg=beets
pip install -U discogs_client pylast beautifulsoup4 requests

# Install poetry
echo "Installing Poetry..."
curl -sSL https://install.python-poetry.org | python3 -

# Install AWS cli
echo "Installing AWS CLI (install for all, as errors have happened for local)..."
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o ~/Downloads/AWSCLIV2.pkg && open ~/Downloads/AWSCLIV2.pkg

# Glcoud install
# https://cloud.google.com/sdk/docs/quickstart-macos
echo "Installing gcloud..."
mkdir -p ~/.gcloud && wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-288.0.0-darwin-x86_64.tar.gz -O ~/Downloads/google-cloud-sdk-288.0.0-darwin-x86_64.tar.gz && tar -zxf ~/Downloads/google-cloud-sdk-288.0.0-darwin-x86_64.tar.gz --directory ~/.gcloud/ && ~/.gcloud/google-cloud-sdk/install.sh

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

# Info about using RCM
# TODO: RCM is not really updated, doesn't support spaces, and doesn't support directories
# without dots (i.e. Library), so should find another solution.
# TODO: Is the absolute path needed here?
echo "Now, link the dotfiles with something like: rcup -d $(pwd)/ [-f]"

# Manually link up the Library (VS Code) files.
echo "Linking VS Code settings..."
VS_CODE_SETTINGS_DIR=~/Library/Application\ Support/Code/User
mkdir -p $VS_CODE_SETTINGS_DIR
if test -f "$VS_CODE_SETTINGS_DIR/settings.json"; then
  mv "$VS_CODE_SETTINGS_DIR/settings.json" "$VS_CODE_SETTINGS_DIR/settings.json.bak"
fi
ln -s $(pwd)/Library/Application\ Support/Code/User/settings.json "$VS_CODE_SETTINGS_DIR/settings.json"

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

# Create a new SSH key
# https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
# ssh-keygen -t ed25519 -C "your_email@example.com"
echo "Create a new SSH key and upload to Github: https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent"