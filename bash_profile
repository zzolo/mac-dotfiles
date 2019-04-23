
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

# Homebrew node location
if [ -e "$(brew --prefix node)/bin" ]; then
  export PATH="$(brew --prefix node)/bin:$PATH"
fi

if [ -e $NPM_PACKAGES/share/man ]; then
  unset MANPATH;
  export MANPATH="$NPM_PACKAGES/share/man:$(manpath)";
fi

# NVM support
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# Python
# (pip with --user, and Homebrew python)
######
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


# Sensitive information
#######
if [ -e $HOME/.zzolo/sensitive ]; then
  source $HOME/.zzolo/sensitive;
fi