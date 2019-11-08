#
# ~/.bash_profile
#

GUIX_PROFILE="/home/alex/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale

#export PATH="$HOME/.config/guix/current/bin:$PATH"
#export INFOPATH="$HOME/.config/guix/current/share/info:$INFOPATH"

[[ -f ~/.bashrc ]] && . ~/.bashrc
