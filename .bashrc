
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PS1="\$(if [[ \$? == 0 ]]; then echo \"\[\033[01;32m\]:)\"; else echo \"\[\033[01;31m\]:(\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[01;31m\]\h\[\033[01;34m\] \w \$'; else echo '\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \#'; fi) \[\033[00m\] "

# Better bash auto completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'
bind 'TAB:menu-complete'

# Set vim as the default editor
export EDITOR='vim'
export VISUAL='vim'

# Colorized ls
export LS_OPTIONS='--color=auto'
eval "$(dircolors --sh)"
alias ls='ls $LS_OPTIONS'

# Aliases: System
#alias pp="dnf update -y" # Fedora
#alias pp="apt-get update && apt-get upgrade -y --no-install-recommends && apt-get dist-upgrade --no-install-recommends" # Debian
alias pp="update_engine_client -update" # CoreOS
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias l='ls --color -aCFhlX --group-directories-first'
alias ll='ls -lh'
alias la='ls -lAh'
alias lsa='ls -lah'
alias lsd='ls -lad */ .*/'
alias dux='du -hs | sort -h'
alias dus='du --block-size=MiB --max-depth=1 | sort -n'
alias clr='printf "\ec"'
alias 755='find . -type d -exec chmod 755 {} \; && echo "Done!";'
alias 644="find . -type f -not -name '.git' -not -name '*.sh' -exec chmod 644 {} \; && echo 'Done!';"

# Aliases: Misc
alias s='sudo -i'
alias getip='curl -4 icanhazip.com'
alias getip6='curl -6 icanhazip.com'
alias getptr='curl -4 icanhazptr.com'
alias ta='tmux attach'
alias t='tmux'
alias ccze="ccze -A"

# Aliases: Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
#alias --='cd -'

# Aliases: Systemd
alias sc='systemctl'
alias scs='systemctl status'
alias scr='systemctl restart'
alias jc='journalctl'
alias jcd='journalctl --disk-usage && journalctl --verify'
alias jcdd='journalctl --vacuum-size=1G'

# Aliases: CoreOS
alias hh='~/coreos_helper.sh'
alias fc='fleetctl'
alias fcl='fleetctl list-units'
alias fclw='watch -n 1 fleetctl list-units'
alias fcf='fleetctl list-unit-files'
alias fcm='fleetctl list-machines'
alias ec='etcdctl'

# Aliases: CoreOS Logs
alias jcf='journalctl -f -u nginx@1 -u php5@1 -u php7@1 -u php7-dev@1 -u redis@1 -u smtp'
alias jcfd='journalctl -f -u nginx@1 -u php5@1 -u php7@1 -u php7-dev@1 -u redis@1 -u smtp -u mysql-dev -u zendserver -u couchdb -u nodejs'

# Aliases: Docker
alias d='docker'
alias di='docker images'
alias dps='docker ps'
alias dpa='docker ps -a'
alias ds='docker stats $(docker ps -q)' # Monitor all containers
alias dr='docker run -t -i'
alias dp='docker pull'
alias dl='docker ps -l -q' # Get latest container ID
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'" # Get container IP
alias drm='docker rm $(docker ps -a -q)' # Remove stopped containers
alias drmi='docker rmi $(docker images -q -f dangling=true)' # Remove untagged images
alias drmv='docker volume ls -qf dangling=true | xargs -r docker volume rm' # Remove orphaned volumes
alias dc='sudo docker-compose'
dup() { alias | docker images | awk '(NR>1) && ($2!~/none/) {print $1":"$2}'| xargs -L1 docker pull; } # Update all docker images
de() { if [ -z "$2" ]; then docker exec -ti -u root "$1" /bin/bash; else docker exec "$1" "$2"; fi } # Enter docker container or execute command
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; } # Show all aliases related docker

# Aliases: rkt
# alias rr='rkt'
# alias rri='rkt image list'
# alias rrps='rkt list'
# alias rrr='rkt run --interactive'
# alias rre='rkt enter'

# Optional
#test -z "$TMUX" && (echo "tmux ls" && tmux ls)
