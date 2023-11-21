# Variables
#####
export CLICOLOR=1
export EDITOR=nano
if type "code" > /dev/null; then
  export EDITOR=code
fi


# Homebrew
#######
if [ -e /usr/local/sbin ]; then
  export PATH="/usr/local/sbin:$PATH";
fi
# GNU version of tools
if [ -e /usr/local/opt/gnu-sed/libexec/gnubin ]; then
  export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH";
fi

# Sqlite
if [ -e /usr/local/opt/sqlite/bin ]; then
  export PATH="/usr/local/opt/sqlite/bin:$PATH"
fi


# Node (local user)
# https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md
######
mkdir -p $HOME/.npm-packages;
NPM_PACKAGES=$HOME/.npm-packages;
if [ -e $NPM_PACKAGES/bin ]; then
  PATH=$NPM_PACKAGES/bin:$PATH;
fi

# Homebrew node location (messes with NVM)
# if [ -e "$(brew --prefix node)/bin" ]; then
#   export PATH="$(brew --prefix node)/bin:$PATH"
# fi

if [ -e $NPM_PACKAGES/share/man ]; then
  unset MANPATH;
  export MANPATH="$NPM_PACKAGES/share/man:$(manpath)";
fi

# NVM support
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s $(brew --prefix nvm)/nvm.sh ] && source $(brew --prefix nvm)/nvm.sh
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# Python
# (pip with --user, and Homebrew python)
######

# ??
if [ -e /usr/local/opt/python/libexec/bin ]; then
  export PATH="/usr/local/opt/python/libexec/bin:$PATH"
fi

# Pip user installed command
if [ -e $HOME/.local/bin ]; then
  export PATH=$HOME/.local/bin:$PATH;
fi
if [ -e $HOME/Library/Python/3.6/bin ]; then
  export PATH=$HOME/Library/Python/3.6/bin:$PATH;
fi
if [ -e $HOME/Library/Python/3.7/bin ]; then
  export PATH=$HOME/Library/Python/3.7/bin:$PATH;
fi
if [ -e $HOME/Library/Python/3.8/bin ]; then
  export PATH=$HOME/Library/Python/3.8/bin:$PATH;
fi
if [ -e $HOME/Library/Python/3.9/bin ]; then
  export PATH=$HOME/Library/Python/3.9/bin:$PATH;
fi

# Virtualenv wrapper
# if type "virtualenvwrapper.sh" > /dev/null; then
#   source $(which virtualenvwrapper.sh)
# fi

# Pyenv
if type "pyenv" > /dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  export PATH="$PYENV_ROOT/shims:$PATH"
  eval "$(pyenv init -)"
  #eval "$(pyenv virtualenv-init -)"
fi

# Poetry
if type "poetry" > /dev/null; then
  export PATH="$HOME/.poetry/bin:$PATH"
  export PATH="$HOME/.local/bin:$PATH"
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

# Alternative with just homebrew
# brew install libpq
# export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


# Manually installed
#######
if [ -e $HOME/Code/installed/bin ]; then
  export PATH="$HOME/Code/installed/bin:$PATH"
fi


# GPG (commit signing)
#######
export GPG_TTY=$(tty)


# Core aliases
#####
alias ls='ls -Gah1';
alias mkdir='mkdir -p';
alias reload='source ~/.bash_profile';
alias cleardns='dscacheutil -flushcache'
alias locate-update='/usr/libexec/locate.updatedb'
alias python-http='python -m SimpleHTTPServer 8000'
alias download='curl -O'
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'
alias preview='qlmanage -p'

# LS with coreutils
if type "gls" > /dev/null; then
  eval $( gdircolors -b $HOME/.dircolors );
  alias ls='gls -Gah1 --color';
fi

# Use hub if installed
if type "hub" > /dev/null; then
  alias git=hub;
fi

# Alias trash (npm trash-cli) command
if type "trash" > /dev/null; then
  alias rm='trash'
fi

# Custom beet wrapper to handle SQLite over network
# https://github.com/beetbox/beets/issues/1976
function beetcopy() {
  if type "beet" > /dev/null; then
    if [ -e /Volumes/Multimedia/tunes/ ]; then
      beet "$@" && \
      echo "Beet done; copying..." && \
      cp ~/.config/beets/config.yaml /Volumes/Multimedia/tunes/beets.conf && \
      cp ~/.config/beets/beets.db /Volumes/Multimedia/tunes/beets.db && \
      cp ~/.config/beets/beets.log /Volumes/Multimedia/tunes/beets.log;
    else
      echo "Music library not found.";
      return 1;
    fi
  else
    echo "Beet not found.";
    return 1;
  fi
}
function beetnocopy() {
  if type "beet" > /dev/null; then
    if [ -e /Volumes/Multimedia/tunes/ ]; then
      beet "$@";
    else
      echo "Music library not found.";
      return 1;
    fi
  else
    echo "Beet not found.";
    return 1;
  fi
}
function beetget() {
  if [ -e /Volumes/Multimedia/tunes/ ]; then
    echo "Getting beet files..." && \
    cp /Volumes/Multimedia/tunes/beets.conf ~/.config/beets/config.yaml && \
    cp /Volumes/Multimedia/tunes/beets.db ~/.config/beets/beets.db  ;
  else
    echo "Music library not found.";
    return 1;
  fi
}


# Sensitive information
#######
if [ -e $HOME/.zzolo/sensitive ]; then
  source $HOME/.zzolo/sensitive;
fi
