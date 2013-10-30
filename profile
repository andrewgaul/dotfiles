#!/bin/bash
# Andrew Gaul's bash .profile

export BROWSER="google-chrome"
export DOGFOOD="/tmp/mountpoint"
export EDITOR="vim"
export GREP_OPTIONS="--color=auto --exclude=\*.svn-base --exclude=Entries"
#export JAVA_HOME="$HOME/work/jdk1.6.0_45"
export JAVA_HOME="$HOME/work/jdk1.7.0_45"
#export JAVA_HOME="$HOME/work/jdk1.8.0"
export LESS="--IGNORE-CASE --RAW-CONTROL-CHARS"
export MAILER="mutt"
export NNTPSERVER="reader443.eternal-september.org"
export PAGER="less"
export PATH="${HOME}/bin:${JAVA_HOME}/bin:${PATH}"
export WWW_HOME="http://google.com/"

alias ls="ls --color=auto"
alias mvn="mvn --quiet"
alias pmake="make --jobs=$(($(grep --count ^processor /proc/cpuinfo) + 1))"

# prompt colors
LIGHT_YELLOW="\[\033[1;33m\]"
DARK_PURPLE="\[\033[0;35m\]"
LIGHT_PURPLE="\[\033[1;35m\]"
DEFAULT="\[\033[0m\]"

# display prompt, prepending exit code if non-zero, e.g., [1] $host [$dir]$
show_if_error() {
    local AUX=$?
    local PREFIX=""
    [ $AUX -gt 0 ] && PREFIX="${LIGHT_YELLOW}[${AUX}] "
    PS1="${PREFIX}${DARK_PURPLE}\h [\w]${LIGHT_PURPLE}\$${DEFAULT} "
}

PROMPT_COMMAND=show_if_error

# disable command suggestion
command_not_found_handle() {
    echo "bash: $1 command not found"
    return 1
}

# MySQL has a perror(1)
errno() {
    awk "/^#define/ && \$3 == $1" \
            /usr/include/asm-generic/errno-base.h \
            /usr/include/asm-generic/errno.h
}

flv_to_mp4() {
    FILENAME=$1
    ffmpeg -vcodec copy -acodec copy -i "${FILENAME}" "${FILENAME%.flv}.mp4"
}

fvim() {
    vim $(find -name "$1")
}

# generate a random password excluding characters which look similar
genpwd() {
    tr -cd 'A-Za-z0-9' < /dev/urandom | tr -d '0O1lI5S6G8B' | head -c 8
    echo
}

mount_gaulbackup() {
    s3fs gaulbackup "${HOME}/gaulbackup" \
        -ouse_rrs=1 \
        -opasswd_file="${HOME}/private/.passwd-s3fs"
}

# mount private encrypted directory
mount_private() {
    encfs ${HOME}/Dropbox/private/ ${HOME}/private/
}

# runs checkstyle and dumps a textual representation
mvn_checkstyle() {
    mvn checkstyle:checkstyle \
        --quiet \
        -Dcheckstyle.output.file=/dev/stdout \
        -Dcheckstyle.output.format=plain \
        $*
}

# compact time replacement
tinytime() {
    /usr/bin/time -f 'total: %E user: %U sys: %S' $*
}

ulimit -c unlimited
