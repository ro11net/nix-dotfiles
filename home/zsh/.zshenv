# XDG Base directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_BIN_HOME="$HOME/.local/bin"

export ZSH_DISABLE_COMPFIX=true
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export HISTFILESIZE=1000000000
export SAVEHIST=1000000000

export FZF_DEFAULT_OPTS='--reverse --ansi'

if [ -d $HOME/.config/env ] && [ ! -z "$(ls -A $HOME/.config/env)" ]; then
  for file in $(find $HOME/.config/env -name "*.env")
  do
    source $file
  done
fi

export CDPATH=$HOME:$HOME/Projects:$HOME/Documents

export EDITOR="nvim"
export BROWSER='/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --profile-directory="Profile 1"'
export MANPAGER="nvim +Man!"
export PAGER=bat
export LESSHISTFILE="$XDG_DATA_HOME/lesshst"
export ZSH="$XDG_CONFIG_HOME/oh-my-zsh"
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ohmyzsh"
export DISABLE_AUTO_UPDATE="true"
export ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml

export PATH="$XDG_BIN_HOME:$PATH"

# krew envs
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# Golang envs
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$GOPATH/bin:$PATH"
export GOPRIVATE="code.il2.gamewarden.io/gamewarden/platform/gravity"
export GONOSUMDB="code.il2.gamewarden.io"

# Needed to use gpg key for signing commits
export GPG_TTY=$(tty)
