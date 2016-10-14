# modify the prompt to contain git branch name if applicable
git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null)
  if [[ -n $ref ]]; then
    echo "[%{$fg_bold[green]%}${ref#refs/heads/}%{$reset_color%}] "
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

# Allow [ or ] whereever you want
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

# load rbenv if available
if which rbenv &>/dev/null ; then
  eval "$(rbenv init - --no-rehash)"
fi

# load thoughtbot/dotfiles scripts
export PATH="$HOME/.bin:$PATH"

# mkdir .git/safe in the root of repositories you trust
export PATH=".git/safe/../../bin:$PATH"

export GOPATH="$HOME/workspace/go/"
export PATH="$PATH:$GOPATH/bin"

export PATH=node_modules/.bin:$PATH
alias gulp="nocorrect gulp"
alias grunt="nocorrect grunt"

export PATH="$HOME/Library/Haskell/bin:$PATH"

export CLASSPATH="/usr/share/java/*.jar"

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

