# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  ref=${ref#refs/heads/}
  rev=$(git name-rev HEAD 2> /dev/null)
  rev=${rev#HEAD }

  if [[ -n $ref ]]; then
    echo "[%{$fg_bold[green]%}${ref}%{$reset_color%}] "
  elif [[ -n $rev ]]; then
    echo "[%{$fg_bold[green]%}${rev}%{$reset_color%}] "
  fi
}
current_dir_info() {
  echo "%{$fg_bold[blue]%}${PWD##*/}%{$reset_color%} "
}
setopt promptsubst
export PS1='$(git_prompt_info)$(current_dir_info)> '

# load our own completion functions
fpath=(~/.zsh/completion $fpath)

# completion
autoload -U compinit
compinit

# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# makes color constants available
autoload -U colors
colors

# enable colored output from ls, etc
export CLICOLOR=1

# history settings
setopt histignoredups
HISTFILE=~/.zsh_history
HISTSIZE=4096
SAVEHIST=4096

# awesome cd movements from zshkit
setopt autocd autopushd pushdminus pushdsilent pushdtohome cdablevars
DIRSTACKSIZE=5

# Try to correct command line spelling
setopt correct correctall

# Enable extended globbing
setopt extendedglob

# Allow [ or ] wherever you want
unsetopt nomatch

# vi mode
bindkey -v
bindkey jj vi-cmd-mode

# handy keybindings
bindkey "^R" history-incremental-search-backward
bindkey "^P" history-search-backward
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# use neovim as the visual editor
export VISUAL=nvim
export EDITOR=$VISUAL
BASE16_SHELL="$HOME/.config/base16-shell/"

# base16 colorscheme
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

export GOPATH="$HOME/workspace/go"
export PATH="$PATH:$GOPATH/bin"

# Bring in the sbins too
export PATH="$PATH:/sbin"
export PATH="$PATH:/usr/sbin"
export PATH="$PATH:/usr/local/sbin"

# Put installed binaries in /usr/local/bin or ~/.local/bin
export PATH="/usr/local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Installed packages with pip
export PATH="$HOME/Library/Python/3.6/bin:$PATH"

# Installed packages with npm
export PATH="$PATH:$HOME/.local/lib/npm/bin"

# Setup version managers
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# local env outside of source control
[[ -f ~/.env ]] && source ~/.env
