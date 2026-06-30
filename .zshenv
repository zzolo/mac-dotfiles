# .zshenv is loaded on any shell.
###

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


# PNPM support
########
if type "pnpm" > /dev/null; then
  export PNPM_HOME="$HOME/Library/pnpm"
  case ":$PATH:" in
    *":$PNPM_HOME/bin:"*) ;;
    *) export PATH="$PNPM_HOME/bin:$PATH" ;;
  esac
fi


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


# Editor
#####
export EDITOR=nano


# Aliases
#####

# Use hub if installed
if type "hub" > /dev/null; then
  alias git=hub;
fi

# Poe tasks if uv
if type "uv" > /dev/null; then
  alias po='uv run poe'
  if type "sfw" > /dev/null; then
    alias po='sfw uv run poe'
  fi
fi

# Use Socket firewall (sfw) installed
if type "sfw" > /dev/null; then
  alias npm='sfw npm';
  alias uv='sfw uv';
  alias pnpm='sfw pnpm';
fi

# User specific rc that shouldn't be in version control.
if [ -e $HOME/.zshrc-user ]; then
  source ~/.zshrc-user
fi

# Use trash instead of rm/rmdir when available.
# rm() filters flags trash doesn't support (e.g. -rf, -r, -f, -i).
if type "trash" > /dev/null; then
  function rm() {
    local -a files
    local verbose=false
    local help=false
    local end_of_flags=false

    for arg in "$@"; do
      if $end_of_flags; then
        files+=("$arg")
      elif [[ "$arg" == "--" ]]; then
        end_of_flags=true
      elif [[ "$arg" == "-h" || "$arg" == "--help" ]]; then
        help=true
      elif [[ "$arg" == -* ]]; then
        # Preserve verbose; silently drop -r/-f/-i/-d/-R etc.
        [[ "$arg" == *v* ]] && verbose=true
      else
        files+=("$arg")
      fi
    done

    if $help; then
      trash --help
      return
    fi

    if [[ ${#files[@]} -eq 0 ]]; then
      echo "rm: missing operand" >&2
      return 1
    fi

    echo "Using trash instead of rm"
    if $verbose; then
      trash -v "${files[@]}"
    else
      trash "${files[@]}"
    fi
  }
  alias rmdir='rm'
fi
