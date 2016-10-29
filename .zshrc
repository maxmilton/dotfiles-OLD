
# Oh My ZSH
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="mm-wag" # Based on af-magic
export DISABLE_AUTO_UPDATE="true"
export COMPLETION_WAITING_DOTS="true"
export DISABLE_UNTRACKED_FILES_DIRTY="true"
export plugins=(docker git z)
source "$ZSH"/oh-my-zsh.sh

# VIM = <3
export EDITOR="vim"
export VISUAL="vim"

# Spell check commands
setopt CORRECT

# Do fuzzy matching
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'

# Inline alias expansion
globalias() {
  if [[ $LBUFFER =~ [a-zA-Z0-9]+$ ]]; then
    zle _expand_alias
    zle expand-word
  fi
  zle self-insert
}
zle -N globalias
bindkey " " globalias
bindkey "^ " magic-space           # control-space to bypass completion
bindkey -M isearch " " magic-space # normal space during searches

# Make new terminals adopt current directory
source /etc/profile.d/vte.sh

# Compare gzipped sizes of a file
gz() {
  echo -e "\e[93moriginal (all sizes in bytes): \e[0m"
  wc -c < "$1"
  echo -e "\e[91mgzipped -1: \e[0m"
  gzip -c -1 "$1" | wc -c
  echo -e "\e[91mgzipped -5: \e[0m"
  gzip -c -5 "$1" | wc -c
  echo -e "\e[91mgzipped -9: \e[0m"
  gzip -c -9 "$1" | wc -c
}

# Command line calculator
calc () { echo "$*" | tr -d \"-\', | bc -l; }
alias C='noglob calc'

# Aliases: System
alias s='sudo -i'
alias rm='gvfs-trash'
alias cp='cp -i'
alias mv='mv -i'
alias l='ls --color -aCFhlX --group-directories-first'
alias lsd='ls -lad */ .*/'
alias dux='du -hs | sort -h'
alias dus='du --block-size=MiB --max-depth=1 | sort -n'
alias clr='printf "\ec"'
alias 775='find . -type d -exec chmod 775 {} \; && echo "Done!";'
alias 755='find . -type d -exec chmod 755 {} \; && echo "Done!";'
alias 700='find . -type d -exec chmod 700 {} \; && echo "Done!";'
alias 664='find . -type f -not -name ".git" -not -name "*.sh" -exec chmod 664 {} \; && echo "Done!";'
alias 644='find . -type f -not -name ".git" -not -name "*.sh" -exec chmod 644 {} \; && echo "Done!";'
alias 600='find . -type f -not -name ".git" -not -name "*.sh" -exec chmod 600 {} \; && echo "Done!";'

# Aliases: Arch Linux
#alias p='pacaur'
#alias pp='pacaur -Syu'

# Aliases: Fedora
alias pp='dnf update'
if [ $UID -ne 0 ]; then
  alias pp='sudo dnf update'
fi

# Aliases: Systemctl
alias sc='systemctl'
alias jc='journalctl'
alias scs='systemctl status'
alias scr='systemctl restart'
# Use sudo if not root
if [ $UID -ne 0 ]; then
  alias sc='sudo systemctl'
  alias jc='sudo journalctl'
  alias scs='sudo systemctl status'
  alias scr='sudo systemctl restart'
fi

# Aliases: Development
alias srv='http-server -a 127.0.0.1 -p 8880 .'
phan() { docker run -v "$PWD":/mnt/src --rm -u "$(id -u):$(id -g)" cloudflare/phan:latest "$@"; return $?; }
export GOPATH="$HOME/Development/go"
export PATH="$PATH:$GOPATH/bin"

# Aliases: Server
alias ccze="ccze -A"
alias t='tmux'
alias ta='tmux attach'
alias gce='gcloud compute ssh --zone asia-east1-c core@core-1'

# Aliases: Misc
#alias getip='curl -4 icanhazip.com'
alias getip='curl -4 https://labs.wearegenki.com/ip' # Get public IP
alias getip6='curl -6 icanhazip.com'
alias getptr='curl -4 icanhazptr.com'
alias screenoff='sleep 1 && xset dpms force off'
alias m='mplayer'
alias gpaste='gpaste-client'

# Aliases: Git
alias gl='git pull --prune'                   # Pull updates
alias gll='/usr/local/bin/gll'                # Pull updates for ALL sub folders
alias glg="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative --all" # Simple log
alias glgg='git log --stat master@{1} master' # Detailed log
alias gld='git diff --stat master@{1} master' # Show changes since last pull
#alias gp='git pull'
#alias gpush='git push origin HEAD'
alias gd='git diff'
alias gdt='git difftool'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gt='git tag'
alias gs='git status -sb'
alias grm='git ls-files --deleted -z | xargs -0 git rm'
# Show all git related aliases
galias() { alias | grep 'git' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# Aliases: Docker
alias d='docker'
alias di='docker images'
alias dps='docker ps'           # Show running containers
alias dpa='docker ps -a'        # Show all containers including stopped
alias ds='docker stats $(docker ps -q)' # Monitor all containers
alias dcd='sudo sh /etc/dnsmasq.d/update-docker-dns.sh' # Update DNS with running docker containers
alias dr='docker run -ti --rm'  # Run interactively then remove
alias dp='docker pull'          # Pull image from the hub.docker.com
alias dl='docker ps -l -q'      # Get latest container ID
alias dip="docker inspect --format '{{ .NetworkSettings.IPAddress }}'" # Get container IP
alias drm='docker rm $(docker ps -a -q)' # Remove stopped containers
alias drmi='docker rmi $(docker images -q -f dangling=true)' # Remove untagged images
alias drmv='docker volume ls -qf dangling=true | xargs -r docker volume rm' # Remove orphaned volumes
alias dc='sudo docker-compose'
dup() { alias | docker images | awk '(NR>1) && ($2!~/none/) {print $1":"$2}'| xargs -L1 docker pull; } # Update all docker images
de() { if [ -z "$2" ]; then docker exec -ti -u root "$1" /bin/bash -c "export TERM=xterm; exec bash"; else docker exec "$1" "$2"; fi } # Enter docker container or execute command
# Show all docker related aliases
dalias() { alias | grep 'docker' | sed "s/^\([^=]*\)=\(.*\)/\1 => \2/"| sed "s/['|\']//g" | sort; }

# Upadte ALL the things!
#alias pp-aws='sudo pip install --upgrade awscli aws-shell'
alias pp-gce='echo "y"| gcloud components update'
alias pp-zsh='(cd ~/.oh-my-zsh; exec git pull)'
#alias pp-git='(cd ~/Development/Git\ Repos; exec gll)'
alias pp-npm='sudo npm -g update'
#alias ppp='pp -y; pp-aws; pp-gce; pp-zsh; pp-git; pp-npm; dup && drmi'
alias ppp='pp -y; pp-gce; pp-zsh; pp-npm; dup; drmi; drmv'

# Paths
export PATH=$HOME/Scripts:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl
export PATH=$HOME/.google-cloud-sdk/bin:$PATH
export PATH=$HOME/.gem/ruby/gems:$PATH

# Google Cloud SDK
source "/home/max/.google-cloud-sdk/path.zsh.inc"
source "/home/max/.google-cloud-sdk/completion.zsh.inc"

# Tmux
#test -z "$TMUX" && (echo "tmux ls" && tmux ls)

# iBus Japanese input
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# tabtab source for yarn package
[[ -f /home/max/.yarn-config/global/node_modules/tabtab/.completions/yarn.zsh ]] \
&& source /home/max/.yarn-config/global/node_modules/tabtab/.completions/yarn.zsh
