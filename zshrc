PROMPT='%{$fg[blue]%}%{$fg[yellow]%}%n %{$fg[blue]%}at %{$fg[yellow]%}%m %{$reset_color%}%{$fg[blue]%}%~ %{$reset_color%}$(git_prompt)%{$fg[red]%}♦$(rvm-prompt)%{$reset_color%}
%{$fg[blue]%}%(!.#.$)%{$reset_color%} '

RPROMPT=''

export DIRSTACKFILE=~/.zdirs
export DIRSTACKSIZE=8
export GREP_OPTIONS='--color=always'
export HISTFILE=$HOME/.zhistory
export HISTSIZE=50000
export KEYTIMEOUT=1
export LESS='-R'
export SAVEHIST=10000
export ZLS_COLORS=$LS_COLORS

stty -ixon

autoload -U colors && colors
autoload -U compinit && compinit

setopt APPEND_HISTORY
setopt AUTO_CD
setopt AUTO_PUSHD
setopt EXTENDED_GLOB
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt NO_FLOW_CONTROL
setopt PROMPT_SUBST
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS
setopt PUSHD_SILENT
setopt PUSHD_TOHOME

## ZSTYLE ##
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' users off
zstyle ':completion:*' verbose yes
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:hosts' hosts $hosts

## BINDKEYS ##
bindkey -v '^r' history-incremental-pattern-search-backward
bindkey -v '^f' history-incremental-pattern-search-forward
bindkey -a 'n' down-line-or-search
bindkey -a 'p' up-line-or-search
bindkey -v '^[[3~' delete-char
bindkey -v '^[[7~' beginning-of-line
bindkey -v '^[[8~' end-of-line
bindkey -v '^[[Z' reverse-menu-complete
bindkey -v '^k' kill-buffer
bindkey -v '^m' check-line
bindkey -v '^n' down-line-or-search
bindkey -v '^p' up-line-or-search
bindkey -v '^s' insert-sudo
bindkey -e

## ALIASES ##
alias vim=nvim
alias ack="ack --color"
alias ackbar="ack --ignore-dir=log --ignore-dir=local_files --context"
alias cal="cal -3"
alias cd=" cd"
alias diff="diff -yEbwB --suppress-common-lines"
alias ls=" ls -G"
alias sl="ls"
alias l="ls -h"
alias ll="ls -lh"
alias la="ls -lah"

## YEAH
alias v=vim
alias e=emacs
alias f=foreman

## Rails-y aliases
alias t="bundle exec rspec --color"
alias p="bundle exec rake parallel:spec"
alias raket="bundle exec rake db:migrate db:test:prepare"
alias rakep="bundle exec rake db:migrate 'parallel:rake[db:test:prepare]'"

## GIT ALIASES ##
alias g="git"
alias gc="g c"
alias gd="g d"
alias gs="g s"
alias gb="g b"
alias gf="g f"
alias gx="gitx"

## SNIPPETS ##
if [[ -f $DIRSTACKFILE ]] && [[ $#dirstack -eq 0 ]]; then
    dirstack=( ${(f)"$(< $DIRSTACKFILE)"} )
    [[ -d $dirstack[1] ]] && cd $dirstack[1] && cd $OLDPWD
fi

## FUNCTIONS ##
insert-sudo() {
    sudo="sudo "
    BUFFER="$sudo$BUFFER"
    CURSOR=$(expr $CURSOR + $(expr length $sudo))
}
zle -N insert-sudo

chpwd() {
    print -l $PWD ${(u)dirstack} >$DIRSTACKFILE
}

extract() {
    file=$1
    filename=$(basename "$file")
    extension="${filename#*.}"
    echo "extracting: $extension"
    case $extension in
        'zip')
            unzip $file
            ;;
        'tar.gz')
            tar -xzvf $file
            ;;
    esac
}

check-line() {
    if [ "$BUFFER" = "" ]; then
        return
    fi
    zle accept-line
}
zle -N check-line

# GIT
git_prompt() {
    if git rev-parse --git-dir >/dev/null 2>&1; then
        ref=$(git symbolic-ref HEAD 2>/dev/null || git name-rev --name-only --no-undefined --always HEAD)
        ref=${ref#refs/heads/}
        extra="*"
        stash=""
        if git diff --quiet --ignore-submodules HEAD >/dev/null 2>&1; then
            extra=""
        fi
        if [ "$(git stash list 2>/dev/null)" != "" ]; then
            stash=" ±stash"
        fi
        echo "%{$fg[yellow]%}±$ref$extra%{$fg[red]%}$stash%{$reset_color%} "
    fi
}

# from http://stackoverflow.com/a/904023
function mandelbrot {
    local lines columns colour a b p q i pnew
    ((columns=COLUMNS-1, lines=LINES-1, colour=0))
    for ((b=-1.5; b<=1.5; b+=3.0/lines)) do
        for ((a=-2.0; a<=1; a+=3.0/columns)) do
            for ((p=0.0, q=0.0, i=0; p*p+q*q < 4 && i < 32; i++)) do
                ((pnew=p*p-q*q+a, q=2*p*q+b, p=pnew))
            done
            ((colour=(i/4)%8))
            echo -n "\\e[4${colour}m "
        done
        echo
    done
}

# Evil!
export EDITOR=emacs

# May need this for colors over ssh!
# export TERM=xterm-color

# Better have something setted -- ssh
export LANG=en_US.UTF-8

# bin folder
export PATH=$HOME/bin:$PATH

# brew
export PATH=/usr/local/bin:$PATH

# Add RVM to PATH for scripting
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting
# Add the following to your ~/.bashrc or ~/.zshrc
#
# Alternatively, copy/symlink this file and source in your shell.  See `hitch --setup-path`.

hitch() {
  command hitch "$@"
  if [[ -s "$HOME/.hitch_export_authors" ]] ; then source "$HOME/.hitch_export_authors" ; fi
}
alias unhitch='hitch -u'

# Persist pair info between terminal instances
# hitch()

if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then
  update_terminal_cwd() {
    local URL_PATH=''
    {
      local i ch hexch LANG=C
      for ((i = 1; i <= ${#PWD}; ++i)); do
        ch="$PWD[i]"
        if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
          URL_PATH+="$ch"
        else
          hexch=$(printf "%02X" "'$ch")
          URL_PATH+="%$hexch"
        fi
      done
    }

    local PWD_URL="file://$HOST$URL_PATH"
    printf '\e]7;%s\a' "$PWD_URL"
  }

  autoload add-zsh-hook
  add-zsh-hook precmd update_terminal_cwd

  update_terminal_cwd
fi

# Tarsnap
alias tarsnap="tarsnap --configfile $HOME/.tarsnap/tarsnap.conf"

# Go
export GOPATH=$HOME/go

# Activator
export PATH=$PATH:$HOME/activator-1.3.2

# boot2docker
export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/iconpin/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1
