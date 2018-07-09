export BROWSER=/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome

# Emacs style key binding
bindkey -e

# プロンプトのカラー表示を有効
autoload -U colors
colors

# デフォルトの補完機能を有効
autoload -U compinit
compinit

# bashの補完機能を有効
autoload -U bashcompinit
bashcompinit

# 履歴ファイルに時刻を記録
setopt extended_history

# 履歴の共有
setopt share_history

# historyコマンドをhistoryに含めない
setopt hist_no_store

# 直前と同じコマンドをhistoryに保存しない
setopt hist_ignore_dups

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加
setopt append_history

# コマンドが入力されるとすぐに追加
setopt inc_append_history

HISTFILE=~/.zsh/zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

# historyy で前表示
function historyy { history -E 1 }

# ベルを鳴らさない。
setopt no_beep

# rm * を実行する前に確認される。
setopt rmstar_wait

# バックグラウンドジョブが終了したらすぐに知らせる。
setopt no_tify

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# コマンドの実行直後に右プロンプトが消える
setopt transient_rprompt

# C-s, C-qを無効にする
setopt no_flow_control

#gitブランチ名表示
autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '(%s)-[%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}

# プロンプト
case ${UID} in
0)
    PROMPT="%B%{${fg[red]}%}${USER}%{${reset_color}%}%b@%{${fg[green]}%}${HOST%%.*}%B%{${fg[red]}%}#%{${reset_color}%}%b "
    RPROMPT="%{${fg[cyan]}%}[%~]%{${reset_color}%}"
    ;;
*)
    PROMPT="${USER}@%{${fg[green]}%}${HOST%%.*}%{${fg[red]}%}%%%{${reset_color}%} "
    RPROMPT="%1(v|%F{green}%1v%f|)%{${fg[cyan]}%}[%~]%{${reset_color}%}"
    ;;
esac

# alias
case "${OSTYPE}" in
darwin*)
    alias ls="ls -G -w -F"
    ;;
linux*|cygwin)
    alias ls="ls -G -F --color=auto"
    ;;
esac

alias jn="jupyter notebook"
alias jl="jupyter lab"
alias py="python"
alias ipy="ipython"
alias mps="mix phx.server"

if [ -x /usr/bin/ptrash ]
then
    alias rm='ptrash -i'
elif [ -x /usr/local/bin/ptrash ]
then
    alias rm='/usr/local/bin/ptrash -i'
else
    alias rm='rm -i'
fi

alias l='ls -G'
alias mv='mv -i'
alias man="LANG= LC_ALL= man"
alias info="info --vi-keys"
alias g="git"
alias be="bundle exec"
alias td="mkdir ~/tmp/$(date '+%Y%m%d-%H%M') && cd ~/tmp/$(date '+%Y%m%d-%H%M')"

export GOPATH=$HOME/.go
export LANG=ja_JP.UTF-8
export PATH=$PATH:$GOPATH/bin
export MANPATH=$MANPATH
export EDITOR=vim
export PAGER=less
export LESS='-R -X'

# completions
fpath=(/usr/local/share/zsh-completions $fpath)

if [ -d $HOME/.pyenv ]
then
    export PATH="$HOME/.pyenv/bin:$PATH"
    eval "$(pyenv init -)"
fi

# plenv
if [ -d $HOME/.plenv ]
then
    export PATH="$HOME/.plenv/bin:$HOME/.plenv/shims:$PATH"
    eval "$(plenv init -)"
fi

# rbenv
if [ -d $HOME/.rbenv ]
then
    export PATH="$HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH"
    eval "$(rbenv init -)"
    if [ -f $HOME/.rbenv/completions/rbenv.zsh ]
    then
        source $HOME/.rbenv/completions/rbenv.zsh
    fi
fi

# nodebrew
if [ -d $HOME/.nodebrew ]
then
    export PATH=$HOME/.nodebrew/current/bin:$PATH
fi

# mysqlenv
[ -f ~/.mysqlenv/etc/bashrc ] && source ~/.mysqlenv/etc/bashrc

eval "$(direnv hook zsh)"

export _Z_CMD=j
#source $HOME/.zsh/z/z.sh

# function
# pecoでzshのコマンド履歴検索
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection

# google検索
function ggle(){
    if [ $(echo $1 | egrep "^-[cfs]$") ]; then
        local opt="$1"
        shift
    fi
    local url="https://www.google.co.jp/search?q=${*// /+}"
    local app="/Applications"
    local g="${app}/Google Chrome.app"
    local f="${app}/Firefox.app"
    local s="${app}/Safari.app"
    case ${opt} in
        "-g")   open "${url}" -a "$g";;
        "-f")   open "${url}" -a "$f";;
        "-s")   open "${url}" -a "$s";;
        *)      open "${url}";;
    esac
}

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
export PIPENV_VENV_IN_PROJECT=true
#xonsh
