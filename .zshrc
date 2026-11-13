# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# exceptions to auto-correction
# alias man='nocorrect man'
# alias mkdir='nocorrect mkdir'
# alias mv='nocorrect mv'
# alias sudo='nocorrect sudo'
# alias fd='nocorrect fd'
# alias storybook='nocorrect storybook'

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  jj
  ssh-agent
)

source $ZSH/oh-my-zsh.sh

# Completion
# autoload -U compinit
# compinit -u

# Prompt

autoload -U colors
colors

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f" # default 'S'
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f" # default 'U'
zstyle ':vcs_info:*' use-simple true
zstyle ':vcs_info:git+set-message:*' hooks git-large-repo git-untracked
zstyle ':vcs_info:git*:*' formats '[%b%m%c%u] ' # default ' (%s)-[%b]%c%u-'
zstyle ':vcs_info:git*:*' actionformats '[%b|%a%m%c%u] ' # default ' (%s)-[%b|%a]%c%u-'

typeset -g ZSH_GIT_PROMPT_LARGE_REPO=0
typeset -g ZSH_GIT_PROMPT_LARGE_REPO_FILE_LIMIT=${ZSH_GIT_PROMPT_LARGE_REPO_FILE_LIMIT:-50000}
typeset -g ZSH_GIT_PROMPT_LARGE_REPO_ICON=${ZSH_GIT_PROMPT_LARGE_REPO_ICON:-▲}
typeset -gA ZSH_GIT_PROMPT_REPO_SIZE_CACHE

function git-prompt-is-large-repo() {
  emulate -L zsh

  local git_dir file_count
  git_dir=$(command git rev-parse --git-dir 2> /dev/null) || return 1
  git_dir=${git_dir:A}

  if [[ -z ${ZSH_GIT_PROMPT_REPO_SIZE_CACHE[$git_dir]} ]]; then
    file_count=$(command git ls-files --cached 2> /dev/null | command wc -l)
    file_count=${file_count//[[:space:]]/}
    [[ $file_count == <-> ]] || file_count=0

    if (( file_count > ZSH_GIT_PROMPT_LARGE_REPO_FILE_LIMIT )); then
      ZSH_GIT_PROMPT_REPO_SIZE_CACHE[$git_dir]=1
    else
      ZSH_GIT_PROMPT_REPO_SIZE_CACHE[$git_dir]=0
    fi
  fi

  [[ ${ZSH_GIT_PROMPT_REPO_SIZE_CACHE[$git_dir]} == 1 ]]
}

function git-prompt-vcs-info() {
  emulate -L zsh

  if git-prompt-is-large-repo; then
    ZSH_GIT_PROMPT_LARGE_REPO=1
    zstyle ':vcs_info:*' check-for-changes false
  else
    ZSH_GIT_PROMPT_LARGE_REPO=0
    zstyle ':vcs_info:*' check-for-changes true
  fi

  vcs_info
}

function +vi-git-large-repo() {
  emulate -L zsh
  if (( ZSH_GIT_PROMPT_LARGE_REPO )); then
    hook_com[misc]+="%F{yellow}${ZSH_GIT_PROMPT_LARGE_REPO_ICON}%f"
  fi
}

function +vi-git-untracked() {
  emulate -L zsh
  if (( ZSH_GIT_PROMPT_LARGE_REPO )); then
    return
  fi

  if command git status --porcelain=v1 --untracked-files=normal --ignore-submodules=dirty 2> /dev/null | command grep -q '^?? '; then
    hook_com[unstaged]+="%F{blue}●%f"
  fi
}

if [[ -n ${ZSH_JJ_PROMPT_FD:-} ]]; then
  zle -F "$ZSH_JJ_PROMPT_FD"
  exec {ZSH_JJ_PROMPT_FD}<&-
fi

typeset -g ZSH_JJ_PROMPT_FD=""
typeset -g ZSH_JJ_PROMPT_WORKSPACE=""
typeset -g ZSH_JJ_PROMPT_JOB_WORKSPACE=""
typeset -g ZSH_JJ_PROMPT_DISPLAY=""
typeset -gA ZSH_JJ_PROMPT_CACHE
typeset -gi ZSH_JJ_PROMPT_GENERATION=0
typeset -gi ZSH_JJ_PROMPT_JOB_GENERATION=0

function jj-prompt-workspace() {
  emulate -L zsh

  local directory=${PWD:A}
  while [[ $directory != / && ! -d $directory/.jj ]]; do
    directory=${directory:h}
  done

  reply=""
  if [[ -d $directory/.jj ]]; then
    reply=$directory
  fi
}

function jj-prompt-info() {
  emulate -L zsh

  local revision bookmark distance display

  # Read only the last snapshot; never snapshot files while drawing the prompt.
  if ! revision=$(command jj log \
      --repository "$1" \
      --ignore-working-copy \
      --no-graph \
      --color always \
      -r @ \
      -T 'change_id.shortest(4)' 2>&1); then
    print -r -- "[%F{red}jj error%f] "
    print -r -- "${revision//$'\n'/ }"
    return 1
  fi

  if ! bookmark=$(command jj log \
      --repository "$1" \
      --ignore-working-copy \
      --no-graph \
      --color never \
      -r 'heads(::@ & bookmarks())' \
      -T 'local_bookmarks.map(|b| b.name()).join(", ") ++ "\n"' 2>&1); then
    print -r -- "[%F{red}jj error%f] "
    print -r -- "${bookmark//$'\n'/ }"
    return 1
  fi

  bookmark=${bookmark//$'\n'/, }
  bookmark=${bookmark//\%/%%}
  display=$(print -r -- "$revision" | command sed -E $'s/\033\\[[0-9;]*m/%{&%}/g')
  if [[ -n $bookmark ]]; then
    display="$bookmark $display"
    if ! distance=$(command jj log \
        --repository "$1" \
        --ignore-working-copy \
        --color never \
        -r 'heads(::@ & bookmarks())..@' \
        --count 2>&1); then
      print -r -- "[%F{red}jj error%f] "
      print -r -- "${distance//$'\n'/ }"
      return 1
    fi
    if (( distance > 0 )); then
      display+=" %F{yellow}↑${distance}%f"
    fi
  fi

  print -r -- "[${display}] "
  print -r -- ""
}

function jj-prompt-start() {
  emulate -L zsh

  ZSH_JJ_PROMPT_JOB_WORKSPACE=$ZSH_JJ_PROMPT_WORKSPACE
  ZSH_JJ_PROMPT_JOB_GENERATION=$ZSH_JJ_PROMPT_GENERATION
  if ! exec {ZSH_JJ_PROMPT_FD}< <(jj-prompt-info "$ZSH_JJ_PROMPT_JOB_WORKSPACE"); then
    vcs_info_msg_0_="[%F{red}jj error%f] "
    return 1
  fi

  if ! zle -F "$ZSH_JJ_PROMPT_FD" jj-prompt-callback; then
    exec {ZSH_JJ_PROMPT_FD}<&-
    ZSH_JJ_PROMPT_FD=""
    vcs_info_msg_0_="[%F{red}jj error%f] "
    return 1
  fi
}

function jj-prompt-callback() {
  emulate -L zsh

  local fd=$1 display error
  local -i changed=0
  zle -F "$fd"
  if ! IFS= read -r -u "$fd" display ||
      ! IFS= read -r -u "$fd" error; then
    display="[%F{red}jj error%f] "
    error="jj prompt: background job ended without a complete result"
  fi
  exec {fd}<&-
  ZSH_JJ_PROMPT_FD=""

  # A result from before the latest command must not overwrite newer state.
  if [[ $ZSH_JJ_PROMPT_JOB_WORKSPACE != $ZSH_JJ_PROMPT_WORKSPACE ]] ||
      (( ZSH_JJ_PROMPT_JOB_GENERATION != ZSH_JJ_PROMPT_GENERATION )); then
    if [[ -n $ZSH_JJ_PROMPT_WORKSPACE ]]; then
      jj-prompt-start
    fi
    return
  fi

  if [[ -z $error ]]; then
    ZSH_JJ_PROMPT_CACHE[$ZSH_JJ_PROMPT_WORKSPACE]=$display
  fi
  if [[ $vcs_info_msg_0_ != $display ]]; then
    changed=1
  fi
  ZSH_JJ_PROMPT_DISPLAY=$display
  vcs_info_msg_0_=$display
  if zle; then
    if (( changed )); then
      zle reset-prompt
      zle -R
    fi
    if [[ -n $error ]]; then
      zle -M "$error"
    fi
  elif [[ -n $error ]]; then
    print -ru2 -- "$error"
  fi
}

function prompt-vcs-info() {
  emulate -L zsh

  local reply=""
  (( ++ZSH_JJ_PROMPT_GENERATION ))
  if command -v jj > /dev/null 2>&1; then
    jj-prompt-workspace
  fi

  if [[ $ZSH_JJ_PROMPT_WORKSPACE != $reply ]]; then
    ZSH_JJ_PROMPT_WORKSPACE=$reply
    ZSH_JJ_PROMPT_DISPLAY=""
    if [[ -n $reply ]]; then
      ZSH_JJ_PROMPT_DISPLAY=${ZSH_JJ_PROMPT_CACHE[$reply]:-}
    fi
  fi

  if [[ -n $ZSH_JJ_PROMPT_WORKSPACE ]]; then
    vcs_info_msg_0_=${ZSH_JJ_PROMPT_DISPLAY:-"[jj] "}
    if [[ -z $ZSH_JJ_PROMPT_FD ]]; then
      jj-prompt-start
    fi
  else
    git-prompt-vcs-info
  fi
}

RPROMPT_BASE="\${vcs_info_msg_0_}%F{blue}%~%f"
setopt PROMPT_SUBST
export PS1=""
if [ $CODESPACES ]; then
  PS1="%F{yellow}%f "
fi
PS1="$PS1$RPROMPT_BASE %F{red}%B%(!.#.$)%b%f "
export RPROMPT=$RPROMPT_BASE

# Hooks

autoload -U add-zsh-hook

typeset -F SECONDS
function record-start-time() {
  emulate -L zsh
  ZSH_START_TIME=${ZSH_START_TIME:-$SECONDS}
}

add-zsh-hook preexec record-start-time

function report-start-time() {
  emulate -L zsh
  if [ $ZSH_START_TIME ]; then
    local DELTA=$(($SECONDS - $ZSH_START_TIME))
    local DAYS=$((~~($DELTA / 86400)))
    local HOURS=$((~~(($DELTA - $DAYS * 86400) / 3600)))
    local MINUTES=$((~~(($DELTA - $DAYS * 86400 - $HOURS * 3600) / 60)))
    local SECS=$(($DELTA - $DAYS * 86400 - $HOURS * 3600 - $MINUTES * 60))
    local ELAPSED=''
    test "$DAYS" != '0' && ELAPSED="${DAYS}d"
    test "$HOURS" != '0' && ELAPSED="${ELAPSED}${HOURS}h"
    test "$MINUTES" != '0' && ELAPSED="${ELAPSED}${MINUTES}m"
    if [ "$ELAPSED" = '' ]; then
      SECS="$(print -f "%.2f" $SECS)s"
    elif [ "$DAYS" != '0' ]; then
      SECS=''
    else
      SECS="$((~~$SECS))s"
    fi
    ELAPSED="${ELAPSED}${SECS}"
    local ITALIC_ON=$'\e[3m'
    local ITALIC_OFF=$'\e[23m'
    # export RPROMPT="%F{cyan}%{$ITALIC_ON%}${ELAPSED}%{$ITALIC_OFF%}%f $RPROMPT_BASE"
    export RPROMPT="%F{cyan}%{$ITALIC_ON%}${ELAPSED}%{$ITALIC_OFF%}%f"
    unset ZSH_START_TIME
  else
    export RPROMPT=""
  fi
}

add-zsh-hook precmd report-start-time

function auto-ls-after-cd() {
  emulate -L zsh
  # Only in response to a user-initiated `cd`, not indirectly (eg. via another
  # function).
  if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
    ls -a
  fi
}
add-zsh-hook chpwd auto-ls-after-cd

add-zsh-hook -d precmd git-prompt-vcs-info
add-zsh-hook precmd prompt-vcs-info

# History
export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE

export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias c="clear"
alias hl="pbpaste | highlight --font-size 36 --font 'IBM Plex Mono' --syntax=js --style Neon -O rtf | pbcopy"
alias vim="nvim"
alias gcom='git checkout $(git_main_branch)'

# Homebrew sbin support
export PATH="/usr/local/sbin:$PATH"
eval "$(brew shellenv)"

OS="$(uname)"
if [[ "${OS}" == "Linux" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Golang support
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

# mise support
eval "$(mise activate zsh)"

# fzf support
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='rg --files --hidden'

# libpq support for pg gem in Rails
# echo 'export PATH="/opt/homebrew/opt/libpq/bin:$PATH"' >> ~/.zshrc

autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /usr/local/bin/terraform terraform
