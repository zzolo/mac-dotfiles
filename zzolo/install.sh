#! /bin/sh

# Install scripts
#####

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "Updating homebrew packages..."
brew update --force

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
  gifsicle
  git
  graphviz
  hub
  imagemagick
  jq
  libjpeg
  libmemcached 
  memcached
  node
  pkg-config
  python
  python@2
  pyenv
  pyenv-virtualenv
  pyenv-virtualenvwrapper
  terminal-notifier
  tree
  vim
  wget
  composer
  drake
  mdbtools
  mysql
  gcc
  openssl
  yarn
  sqlite
  gdal
)

echo "Installing homebrew packages..."
brew install ${PACKAGES[@]}

# Link up Python 3
brew link --overwrite python

# Instal RCM for linking dotfiles
echo "Installing RCM (https://github.com/thoughtbot/rcm)..."
brew tap thoughtbot/formulae
brew install rcm

# Install cask
brew tap homebrew/cask
brew cask install phantomjs

# Instal homebrew cask font
echo "Installing cask-fonts and fonts..."
brew tap homebrew/cask-fonts
brew cask install \
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
  yo
  gulp-cli
  eslint
  trash-cli
)
npm install -g ${NPM_PACKAGES[@]}

echo "Install NVM"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash;

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

# Oh My Zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Get powerline theme
echo "Installing powerline theme"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

# Python packages
pip install awscli csvkit -U

# Info about using RCM
echo "Now, link the dotfiles with something like: rcup -d /path/to/this/directory [-f]"