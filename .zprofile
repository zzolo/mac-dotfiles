# .zprofile is loaded once per login session.  Generally we are using .zshenv for PATH and
# other environment variables related to all shells.
#####

# The system's /etc/zprofile (sourced immediately before this file, for
# login shells) runs path_helper, which reorders $PATH and undoes the
# ordering .zshenv set up. Re-source it now that path_helper is done --
# see the comment at the top of .zshenv for why this is safe/cheap to do
# twice in the same shell.
[ -f "$HOME/.zshenv" ] && source "$HOME/.zshenv"

# Variables
#####
export CLICOLOR=1
export EDITOR=nano
