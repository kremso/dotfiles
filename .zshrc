# Path to your oh-my-zsh configuration.
#export ZSH=$HOME/.oh-my-zsh

export ZSH=$HOME/projects/oh-my-zsh
#export ZSH=$HOME/.oh-my-zsh

# Set to the name theme to load.
# Look in ~/.oh-my-zsh/themes/
export ZSH_THEME="tk"

plugins=(git rails ruby vi-mode)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...

if [[ -s /home/kremso/.rvm/scripts/rvm ]] ; then source /home/kremso/.rvm/scripts/rvm ; fi


source /home/kremso/projects/colfm/colfm.zsh
