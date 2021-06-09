#
# ~/.bash_profile
#

GUIX_PROFILE="/home/alex/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale

export LV2_PATH="/usr/lib/lv2:$HOME/local/lib/lv2"

[[ -f ~/.bashrc ]] && . ~/.bashrc

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
