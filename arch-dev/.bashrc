# ~/.bashrc — shared interactive shell configuration for project containers.

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'

if [[ -f ~/.git-prompt.sh ]]; then
    source ~/.git-prompt.sh
    PROMPT_COMMAND='PS1_CMD1=$(__git_ps1 "(%s) ")'
    PS1='\[\033[38;5;82;3m\]\u\[\033[39;2m\]@\h\[\033[0m\] \w \[\033[38;5;87m\]${PS1_CMD1}\[\033[0m\]\$ '
fi
