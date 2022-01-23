
# try to import some local machine environemnt
source ~/.zsh_env_vars

# show prompt to be directory and $
PROMPT="
 %~ $ "

setopt auto_cd # cd by typing directory name without cd
setopt correct_all # try to correct all commands

# menu
setopt auto_list # auto list choice on ambigious choice
setopt auto_menu # auto use menu completion
setopt always_to_end # always move cursor to end if word has only one match

# vim mode
bindkey -v

autoload -U edit-command-line
zle -N edit-command-line

# try to enable autocompletion
autoload -Uz compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:::::' completer _expand _complete _ignored _approximate

PATH=$PATH:~/go/bin

alias actgh="act --actor bu --secret GITHUB_TOKEN=${GITHUB_TOKEN} --secret ACCESS_TOKEN=${GITHUB_TOKEN}"
