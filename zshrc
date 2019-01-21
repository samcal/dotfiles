# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  ref=$(git name-rev HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    echo "[%{$fg_bold[green]%}${ref#HEAD }%{$reset_color%}] "
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

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

export GOPATH="$HOME/workspace/go"
export PATH="$PATH:$GOPATH/bin"

# Bring in the sbins too
export PATH="$PATH:/sbin"
export PATH="$PATH:/usr/sbin"

# Put installed binaries in /usr/local/bin or ~/.local/bin
export PATH="/usr/local/bin:$PATH"
export PATH="~/.local/bin:$PATH"

# Installed packages with pip
export PATH="/Users/sam/Library/Python/3.6/bin:$PATH"

# Use the binaries from current node_modules. Completion doesn't know about
# these, so we need to nocorrect the important ones.
export PATH=node_modules/.bin:$PATH

# Setup version managers
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
export NVM_DIR="/Users/sam/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases
