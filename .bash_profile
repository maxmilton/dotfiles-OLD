# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH

# Google Cloud SDK
source "$HOME/.google-cloud-sdk/path.bash.inc"
source "$HOME/.google-cloud-sdk/completion.bash.inc"

# iBus Japanese input
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
