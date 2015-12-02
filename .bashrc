# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e ' /^[^*]/d' -e 's/* \(.*\)/:\1/'
}

function redis() {
	if [ -z "$@" ]; then 
		/home/pablo-tapia/redis/src/redis-server /home/leonardo/desarrollo/redis/redis-2.8.8/redis.conf
	else
		echo $@
		/home/pablo-tapia/redis/src/redis-server /home/leonardo/desarrollo/redis/redis-2.8.8/redis.conf --port $@
	fi
}

function redismon() {
	if [ -z "$@" ]; then 
		REDIS_PORT=6379
	else
		REDIS_PORT=$@
	fi
	/home/pablo-tapia/redis/src/redis-cli -p $REDIS_PORT -a luna1234 monitor | grep -v \"PING\|AUTH\"
}

function rediscli() {
	if [ -z "$@" ]; then 
		REDIS_PORT=6379
	else
		REDIS_PORT=$@
	fi
	/home/pablo-tapia/redis/src/redis-cli -p $REDIS_PORT -a luna1234
}

function proml {
  local  BROWN_BOLD="\[\033[0;1;33m\]"
  local         RED="\[\033[0;1;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;1;37m\]"
  local      NORMAL="\[\033[0m\]"
  local        BLUE="\[\033[0;34m\]"

  case $TERM in
    xterm*)
    TITLEBAR='\[\033]0;\W\007\]'
    ;;
    *)
    TITLEBAR=""
    ;;
  esac

PS1="${TITLEBAR}\
$LIGHT_GRAY\
$LIGHT_GRAY\t$LIGHT_GRAY$BROWN_BOLD\W$RED\$(parse_git_branch)$LIGHT_GRAY \
$NORMAL"
PS2='> '
PS4='+ '
}
proml

export JAVA_HOME='/usr/lib/jvm/java-8-oracle'
export PATH=$PATH:$JAVA_HOME/bin

export M2_HOME=/usr/share/maven
export M2=$M2_HOME/bin
#export M2_REPO=/home/pablo-tapia/.m2/repository

#export MAVEN_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,address=4001,server=y,suspend=n -Xmx2048m -XX:MaxPermSize=128m -javaagent:/home/pablo-tapia/.m2/repository/org/springframework/spring-#instrument/3.2.1.RELEASE/spring-instrument-3.2.1.RELEASE.jar"

export PATH=$PATH:/usr/share/grails/2.0.1/bin
export PATH=$PATH:$M2
export PATH=$PATH:$M2_REPO

#THIS MUST BE AT THE END OF THE FILE FOR GVM TO WORK!!!
[[ -s "/home/pablo-tapia/.gvm/bin/gvm-init.sh" ]] && source "/home/pablo-tapia/.gvm/bin/gvm-init.sh"

#THIS MUST BE AT THE END OF THE FILE FOR JENV TO WORK!!!
[[ -s "/home/pablo-tapia/.jenv/bin/jenv-init.sh" ]] && source "/home/pablo-tapia/.jenv/bin/jenv-init.sh" && source "/home/pablo-tapia/.jenv/commands/completion.sh"
