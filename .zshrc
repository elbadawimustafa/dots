# zsh completions from homebrew:
# zmodload zsh/zprof
if [ -d /usr/local/share/zsh/site-functions ]; then
    . /usr/local/share/zsh/site-functions
fi

autoload -Uz compinit colors add-zsh-hook
compinit -u     # autocomplete
colors          # colors
typeset -U PATH # no dupes in PATH

export PATH="$HOME/gd/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

case $(uname); in
  Darwin) export HOMEBREW_PREFIX=$([[ "$(uname -m)" == 'arm64' ]] && echo "/opt/homebrew" || echo "/usr/local") ;;
   Linux) export HOMEBREW_PREFIX="/home/linuxbrew/.linuxbrew"; ;;
esac

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_CELLAR="${HOMEBREW_PREFIX}/Cellar";
export HOMEBREW_REPOSITORY="${HOMEBREW_PREFIX}/Homebrew";
export HOMEBREW_SHELLENV_PREFIX="${HOMEBREW_PREFIX}/"
export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin${PATH+:$PATH}";
export MANPATH="${HOMEBREW_PREFIX}/share/man:/opt/local/share/man${MANPATH+:$MANPATH}:";
export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH:-}";

export PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"

gstat () {
    if test -d ".git"; then
        psvar[1]=" `git rev-parse --abbrev-ref HEAD`"
        psvar[2]=`git diff-index --quiet HEAD -- || printf "*"`
    else
        psvar[1]=""
        psvar[2]=""
    fi
}
# get git meta-information periodically, every 1s
PERIOD=1
add-zsh-hook periodic gstat
# prompt format
PROMPT="%{$fg[blue]%}%4~%{$fg[green]%}%1v%{$fg[red]%}%2v%{$fg_bold[red]%} %# %{$reset_color%}"

HISTFILE=~/.zsh_history                            # where to store zsh config
HISTSIZE=7500                                      # lines of history to keep in mem
SAVEHIST=30000                                     # lines of history to save to file
HISTORY_IGNORE="(history|ls|pwd|exit|ll|la|clear)" # commands history ignores

setopt APPEND_HISTORY           # append
setopt HIST_IGNORE_DUPS         # no duplicate
setopt HIST_IGNORE_ALL_DUPS     # no duplicate
setopt HIST_REDUCE_BLANKS       # trim blanks
setopt SHARE_HISTORY            # share hist between sessions
setopt HIST_IGNORE_SPACE        # ignore commands prefixed by a space
setopt HIST_NO_STORE            # dont store dupes
setopt BANG_HIST                # !keyword
setopt NO_BEEP                  # no terminal beeps
setopt HIST_SAVE_NO_DUPS        # more de-duping
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt INTERACTIVECOMMENTS      # recognize comments on cli
setopt NO_COMPLETE_ALIASES      # autocomplete aliases, this seems to do the opposite of what it sounds like

# completion
zstyle ':completion:*' menu select
# oh-my-zsh style history completion
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward
bindkey '\e[3~' delete-char # 'forward' delete key

# Brightcove:
source ~/.brightcoverc

#Go bin directory
export PATH="$PATH:$HOME/go/bin"
export GOPATH="$HOME/go"
export PATH="$PATH:/opt/homebrew/bin"
eval "$(direnv hook zsh)"
export PATH

#rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"


#bento
export PATH="$PATH:$HOME/bento4"

#bins directory
export PATH="$PATH:$HOME/bins"

# Uninstalls all ruby gems for all rbenv versions
ruby-uninstall-all-gems () {
  for ruby in $(rbenv versions --bare); do
    echo "---------------------------------------"
    echo "$ruby"
    rbenv shell "$ruby"
    for gem in $(gem list --no-versions); do
      gem uninstall "$gem" -aIx
    done
  done
}

ruby-reinstall-all-versions () {
  for ruby in $(rbenv versions --bare); do
    echo "---------------------------------------"
    echo "$ruby"
    rbenv uninstall "$ruby"
    rbenv install "$ruby"
  done
}


alias gu='git fetch --all --prune &&
          git checkout master &&
          git pull origin master --tags &&
          git checkout -'

#jq format
jq-format () {
    TMP=$(jq . < "$1")
    if [[ "$?" != "0" ]]
    then
        echo "Error parsing json: $1"
        return
    fi
    echo "$TMP" > "$1"
}

#cntr-z
function fancy-ctrl-z {
  if [[ $#BUFFER -eq 0 ]]; then
    kill -9 %+
    zle redisplay
  else
    zle push-input
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z
bindkey '\ee'  edit-command-line

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#nvm
export NVM_DIR="$HOME/.nvm"

function ssh-init {
  rm -f "$HOME/.ssh/environment"
  ssh-agent > "$HOME/.ssh/environment"
  chmod 600 "$HOME/.ssh/environment"
  source "$HOME/.ssh/environment" &> /dev/null
  source "$HOME/.ssh/environment" &> /dev/null
  ssh-add -A
}

`source "$HOME/.ssh/environment" &> /dev/null`

#Java path
export JAVA_HOME=jdk-install-dir

export PATH=$JAVA_HOME/bin:$PATH

#Java path for jenv
export PATH="$HOME/.jenv/bin:$PATH"

#fix git init
zgit_info_update() {
    zgit_info=()

    local gitdir=$(git rev-parse --git-dir 2>/dev/null)
    if [ $? -ne 0 ] || [ -z "$gitdir" ]; then
        return
    fi

}

alias active-ports='sudo lsof -PiTCP -sTCP:LISTEN'

alias ..="cd .."
alias gs="git status"
alias gp="git pull && git fetch --all --prune"
alias gb="git branch"
alias ga="git add ."
alias gc="git commit -m $1"
alias gco="git checkout"
alias gst="git status"
alias gd="git diff"
eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$PATH:/opt/homebrew/bin"

eval "$(starship init zsh)"
export JAVA_HOME="$(brew --prefix java)"
export PATH=$JAVA_HOME/bin:$PATH

if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export GPG_TTY="$(tty)"
fi

# libffi
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib -L/opt/homebrew/opt/openssl/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include -I/opt/homebrew/opt/openssl/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"
# zprof
export GPG_TTY=$(tty)

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/melbadawi/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/melbadawi/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/melbadawi/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/melbadawi/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

# Created by `pipx` on 2023-08-07 14:37:32
export PATH="$PATH:/Users/melbadawi/.local/bin"

alias as='awsume'
alias py='python3'
alias mtfp='terraform plan -var-file=dd.tfvars'
alias as=awsume

export ZPLUG_HOME=/opt/homebrew/opt/zplug
source $ZPLUG_HOME/init.zsh


fzy-history() {
  LBUFFER+=$(
  ([ -n "$ZSH_NAME" ] && fc -l 1 || history) \
    | fzy \
    | sed -E 's/ *[0-9]*\*? *//' \
    | sed -E 's/\\/\\\\/g'
  )
  zle reset-prompt
}

zle -N fzy-history
bindkey "^r" fzy-history

fzy-dir() {
  LBUFFER+=$(fd -t d -H | fzy)
  zle reset-prompt
}
zle -N fzy-dir
bindkey "^g" fzy-dir

fzy-file() {
  LBUFFER+=$(fd -t f -H | fzy)
  zle reset-prompt
}
zle -N fzy-file
bindkey "^t" fzy-file

alias vim=nvim

