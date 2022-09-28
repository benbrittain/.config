# vim:ft=zsh ts=4 sw=4 sts=4

CURRENT_BG='NONE'
CURRENT_FG='0'
DEFAULT_USER='ben'

() {
    local LC_ALL="" LC_CTYPE="en_US.UTF-8";
    SEGMENT_SEPARATOR=$'\ue0b0';
}

prompt_segment() {
    local bg fg
    [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
    [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
        echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
    else
        echo -n "%{$bg%}%{$fg%} "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && echo -n $3
}

prompt_status() {
    local -a symbols

    [[ $RETVAL -ne 0 ]] && symbols+="%{%F{1}%}✘"
    [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{3}%}⌖"
    [[ -n "$symbols" ]] && prompt_segment 166 7 "$symbols"
}

prompt_end() {
    if [[ -n $CURRENT_BG ]]; then
        echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
    else
        echo -n "%{%k%}"
    fi
    echo -n "%{%f%}"
    CURRENT_BG=''
}

prompt_dir() {
    prompt_segment 4 $CURRENT_FG '%~'
}

prompt_context() {
    if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
        prompt_segment 237 7 "%(!.%{%F{3}%}.)%n@%m"
    fi
}

prompt_git() {
    local PL_BRANCH_CHAR

    () {
        local LC_ALL="" LC_CTYPE="en_US.UTF-8"
        PL_BRANCH_CHAR=''
    }

    local ref dirty mode repo_path
    if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
        repo_path=$(git rev-parse --git-dir 2>/dev/null)
        dirty=$(parse_git_dirty)
        ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git rev-parse --short HEAD 2> /dev/null)"

        if [[ -n $dirty ]]; then
            prompt_segment 3 0
        else
            prompt_segment 2 $CURRENT_FG
        fi

        setopt promptsubst
        autoload -Uz vcs_info
        zstyle ':vcs_info:*' enable git
        zstyle ':vcs_info:*' get-revision true
        zstyle ':vcs_info:*' check-for-changes true
        zstyle ':vcs_info:*' stagedstr '✚'
        zstyle ':vcs_info:*' unstagedstr '●'
        zstyle ':vcs_info:*' formats ' %u%c'
        zstyle ':vcs_info:*' actionformats ' %u%c'
        vcs_info
        echo -n "${ref/refs\/heads\//$PL_BRANCH_CHAR }${vcs_info_msg_0_%%}"
    fi
}

build_prompt() {
    RETVAL=$?
    prompt_status
    prompt_context
    prompt_dir
    prompt_git
    prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
