# .zshenv is loaded on every zsh invocation (interactive or not, login or
# not) -- including the bare shells that LLM/agent tooling spawns.
#
# For LOGIN shells, macOS's /etc/zprofile runs path_helper right after this
# file, which reorders $PATH and pushes system dirs (/usr/local/bin,
# /usr/bin, ...) back in front of everything set up below. We can't edit
# that system file, so .zprofile re-sources this file after path_helper
# runs. Every block below is written to be cheap and side-effect free on a
# second run in the same shell: path_add() dedupes/reorders instead of
# blindly prepending, and anything that shells out or evals is guarded so
# it only actually runs once per shell.
###

# Adds $1 to the front of $PATH, or moves it to the front if it's already
# present. Safe to call repeatedly, including across a second source of
# this file.
path_add() {
  [ -d "$1" ] || return 0
  path=("$1" ${path:#$1})
}


# Homebrew
#######
if [ -e /opt/homebrew/bin/brew ]; then
  if [ -z "$HOMEBREW_PREFIX" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
  fi
  path_add "/opt/homebrew/bin"
  path_add "/opt/homebrew/sbin"
fi

path_add "/usr/local/sbin"

# GNU version of tools
path_add "/usr/local/opt/gnu-sed/libexec/gnubin"


# Sqlite
#######
path_add "/usr/local/opt/sqlite/bin"


# VS Code
#######
path_add "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"


# NVM support
########
export NVM_DIR="$HOME/.nvm"
if ! typeset -f nvm > /dev/null; then
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s $(brew --prefix nvm)/nvm.sh ] && source $(brew --prefix nvm)/nvm.sh
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi
[ -n "$NVM_BIN" ] && path_add "$NVM_BIN"


# PNPM support
########
if type "pnpm" > /dev/null; then
  export PNPM_HOME="$HOME/Library/pnpm"
  path_add "$PNPM_HOME/bin"
fi


# FNM
########
if type "fnm" > /dev/null; then
  if [ -z "$_dotfiles_fnm_initialized" ]; then
    typeset -g _dotfiles_fnm_initialized=1
    eval "$(fnm env --use-on-cd --shell zsh)"
  fi
  # fnm's own --use-on-cd hook re-applies its PATH entry on every
  # prompt/cd, so it self-corrects after path_helper without help here.
fi


# PHP (composer)
######
path_add "$HOME/.composer/vendor/bin"


# Ruby (rbenv)
######
if type "rbenv" > /dev/null; then
  if ! typeset -f rbenv > /dev/null; then
    eval "$(rbenv init -)"
  fi
  path_add "${RBENV_ROOT:-$HOME/.rbenv}/shims"
fi

# Ruby (local gems)
######
path_add "$HOME/.gem/ruby/2.5.0/bin"


# Rust(up)
#######
path_add "$HOME/.cargo/bin"


# Postgres.app
#######
if [ -e /Applications/Postgres.app/Contents/Versions/latest/bin ]; then
  # Only fall back to Postgres.app's psql if nothing else on PATH already
  # provides one (e.g. a homebrew postgres install). Decide once per shell
  # so re-running this file doesn't flip the decision after we've already
  # added it ourselves.
  if [ -z "$_dotfiles_postgres_app_checked" ]; then
    typeset -g _dotfiles_postgres_app_checked=1
    type "psql" > /dev/null || typeset -g _dotfiles_use_postgres_app=1
  fi
  [ -n "$_dotfiles_use_postgres_app" ] && path_add "/Applications/Postgres.app/Contents/Versions/latest/bin"
fi


# Local bin / uv
#######
path_add "$HOME/.local/bin"


# Manually installed
#######
path_add "$HOME/Code/installed/bin"


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

  # SFW fails too often
  # if type "sfw" > /dev/null; then
  #   alias po='sfw uv run poe'
  # fi
fi

# Use Socket firewall (sfw) installed
if type "sfw" > /dev/null; then

  # SFW fails too often
  # alias npm='sfw npm'
  # alias uv='sfw uv'
  # alias pnpm='sfw pnpm'
fi

# User specific rc that shouldn't be in version control.
if [ -e $HOME/.zshrc-user ]; then
  source ~/.zshrc-user
fi

# Use trash instead of rm/rmdir when available.
# rm() filters flags trash doesn't support (e.g. -rf, -r, -f, -i).
if type "trash" > /dev/null && ! typeset -f rm > /dev/null; then
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
