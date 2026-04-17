# .zprofile is loaded once per login session to set up environment variables (like PATH),
#


# Homebrew
#######
if [ -e /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi
if [ -e /usr/local/sbin ]; then
  export PATH="/usr/local/sbin:$PATH";
fi
# GNU version of tools
if [ -e /usr/local/opt/gnu-sed/libexec/gnubin ]; then
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH";
fi

# Sqlite
#######
if [ -e /usr/local/opt/sqlite/bin ]; then
  export PATH="/usr/local/opt/sqlite/bin:$PATH"
fi


# VS Code
#######
if [ -e "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]; then
  export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
fi


# NVM support
########
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s $(brew --prefix nvm)/nvm.sh ] && source $(brew --prefix nvm)/nvm.sh
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# FNM
########
if type "fnm" > /dev/null; then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi


# PHP (composer)
######
if [ -e $HOME/.composer/vendor/bin ]; then
  export PATH="$HOME/.composer/vendor/bin:$PATH"
fi


# Ruby (rbenv)
######
if type "rbenv" > /dev/null; then
  eval "$(rbenv init -)"
fi

# Ruby (local gems)
######
if [ -e $HOME/.gem/ruby/2.5.0/bin ]; then
  export PATH="$HOME/.gem/ruby/2.5.0/bin:$PATH"
fi


# Rust(up)
#######
if [ -e $HOME/.cargo/bin ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi


# Postgres.app
#######
if [ -e /Applications/Postgres.app/Contents/Versions/latest/bin ]; then
  if type "psql" > /dev/null; then
  else
    export PATH=/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH;
  fi
fi


# Local bin / uv
#######
if [ -e $HOME/.local/bin ]; then
  export PATH="$HOME/.local/bin:$PATH"
fi


# Manually installed
#######
if [ -e $HOME/Code/installed/bin ]; then
  export PATH="$HOME/Code/installed/bin:$PATH"
fi


# Sensitive information
#######
if [ -e $HOME/.zzolo/sensitive ]; then
  source $HOME/.zzolo/sensitive;
fi


# Variables
#####
export CLICOLOR=1
export EDITOR=nano
if type "code" > /dev/null; then
  export EDITOR=code
fi
