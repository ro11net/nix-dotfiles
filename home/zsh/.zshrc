# ░▀▀█░█▀▀░█░█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀
# ░▄▀░░▀▀█░█▀█░░░█░░░█░█░█░█░█▀▀░░█░░█░█
# ░▀▀▀░▀▀▀░▀░▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀

eval "$(/opt/homebrew/bin/brew shellenv)"

export ZDOTDIR="$HOME/.config/zsh"

#######################################################################
# Navigation
#######################################################################
setopt AUTO_CD              # Go to folder path without using cd
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd

setopt CORRECT              # Spelling Corrections
setopt CDABLE_VARS          # Change directory to a path stored in a variable
setopt EXTENDED_GLOB        # Use extended globbing syntax

#######################################################################
# History
#######################################################################
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt INC_APPEND_HISTORY        # Immediately append to history, and not on shell exit
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.


#######################################################################
# Oh My Zsh
#######################################################################
# source $ZSH/oh-my-zsh.sh

#######################################################################
# Aliases
#######################################################################
source $ZDOTDIR/aliases

#######################################################################
# ASDF
#######################################################################
# . $(brew --prefix asdf)/libexec/asdf.sh
# source "${XDG_CONFIG_HOME:-$HOME/.config}/asdf-direnv/zshrc"
# . ${ASDF_DATA_DIR}/plugins/golang/set-env.zsh

#######################################################################
# FUNCTIONS
#######################################################################
autoload -Uz $ZDOTDIR/functions/*

#######################################################################
# FZF
#######################################################################
if [ $(command -v "fzf") ]; then
  source $(brew --prefix fzf)/shell/completion.zsh
  source $(brew --prefix fzf)/shell/key-bindings.zsh
fi

# DIRENV
eval "$(direnv hook zsh)"

# Prompt
eval "$(starship init zsh)"

# History
eval "$(atuin init zsh)"

# flux completion
autoload -Uz compinit
compinit

command -v flux >/dev/null && . <(flux completion zsh)

autoload -Uz $ZDOTDIR/.zshenv