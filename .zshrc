setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt APPEND_HISTORY
setopt CORRECT
setopt EXTENDED_HISTORY
setopt MENUCOMPLETE
setopt ALL_EXPORT
unsetopt BG_NICE

# Set/unset shell options.
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   correctall autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced.
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile

TERM=xterm-256color
HISTFILE=$HOME/.zhistory
HISTSIZE=1000
SAVEHIST=1000
HOSTNAME="`hostname`"
PAGER='less'
EDITOR='vim'
    autoload colors zsh/terminfo
    if [[ "$terminfo[colors]" -ge 8 ]]; then
   colors
    fi
    for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
   eval PR_$color='%{$terminfo[bold]$fg[${(L)color}]%}'
   eval PR_LIGHT_$color='%{$fg[${(L)color}]%}'
   (( count = $count + 1 ))
    done
    PR_NO_COLOR="%{$terminfo[sgr0]%}"
PS1="[$PR_MAGENTA%n$PR_NO_COLOR@$PR_GREEN%U%m%u$PR_NO_COLOR:$PR_RED%2c$PR_NO_COLOR]%(!.#.$) "
RPS1="$PR_MAGENTA(%D{%m-%d %H:%M})$PR_NO_COLOR"
LC_ALL='en_US.UTF-8'
LANG='en_US.UTF-8'
LC_CTYPE=C

if [ $SSH_TTY ]; then
  MUTT_EDITOR=vim
else
  MUTT_EDITOR=emacsclient.emacs-snapshot
fi

unsetopt ALL_EXPORT

autoload -U compinit
compinit
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line
bindkey "^?" backward-delete-char
bindkey '^[OH' beginning-of-line
bindkey '^a' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^e' end-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[6~' down-line-or-history
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' menu select=1 _complete _ignored _approximate
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Completion Styles
## list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
## allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/2 )) numeric )'
## insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions
## formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''
## match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
## command for process lists, the local web server details and host completion
## on processes completion complete all user processes
## zstyle ':completion:*:processes' command 'ps -au$USER'
## add colors to processes for kill completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -A -o pid,user,cmd'
zstyle ':completion:*:processes-names' command 'ps axho command'
## All /etc/hosts hostnames are in autocomplete
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}')
## Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
## ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm apache bin daemon games gdm halt ident junkbust lp mail mailnull \
        named news nfsnobody nobody nscd ntp operator pcap postgres radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs avahi-autoipd\
        avahi backup messagebus beagleindex debian-tor dhcp dnsmasq fetchmail\
        firebird gnats haldaemon hplip irc klog list man cupsys postfix\
        proxy syslog www-data mldonkey sys snort

# SSH Completion
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
zstyle '*' single-ignored show

# Start SSH agent.
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
echo "Initialising new SSH agent..."
/usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
echo succeeded
chmod 600 "${SSH_ENV}"
. "${SSH_ENV}" > /dev/null
/usr/bin/ssh-add;
}

if [ -f "${SSH_ENV}" ]; then
. "${SSH_ENV}" > /dev/null
ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
start_agent;
}
else
start_agent;
fi

# Set alias.
alias man='LC_ALL=C LANG=C man'
alias v="vim"
alias vi="vim"
alias ls='ls --color=auto '
alias ll="ls -la"
alias cdconf="cd /etc/httpd/conf.d/"
alias cdphpcs="cd /usr/share/pear/PHP/CodeSniffer";
alias goconf="cd /etc/httpd/conf.d/"
alias gophpcs="cd /usr/share/pear/PHP/CodeSniffer";
alias restart="sudo /etc/init.d/httpd restart"

# Environment Variables.
export TZ="/usr/share/zoneinfo/Asia/Taipei"
export MAVEN_HOME=/home/m/lib/maven
export PATH="/usr/local/bin:/usr/local/sbin/:/bin:/sbin:/usr/bin:/usr/sbin:${PATH}"
export PATH="${MAVEN_HOME}/bin:/usr/local/maven/bin:${PATH}"

# get the name of the branch we are on
git_prompt_info() {
      ref=$(git symbolic-ref HEAD 2> /dev/null) || return
            echo "(${ref#refs/heads/})"
}
autoload -U colors
colors
setopt prompt_subst
PROMPT='%{$fg[green]%}%n@%m %~ %{$fg[red]%}$(git_prompt_info)%{$reset_color%} %# '