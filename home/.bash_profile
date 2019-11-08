#
# ~/.bash_profile
#

GUIX_PROFILE="/home/alex/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
export GUIX_LOCPATH=$HOME/.guix-profile/lib/locale

[[ -f ~/.bashrc ]] && . ~/.bashrc
