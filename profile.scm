(use-package-modules certs vim shells video audio linux virtualization gnome-xyz
                     pkg-config perl gnuzilla gnome messaging python-xyz music
                     gnupg ssh rsync kde-frameworks build-tools ninja xdisorg
                     backup commencement wget compression vpn admin autogen fonts
                     version-control web pulseaudio tmux algebra gdb curl gtk man
                     fontutils python rdf tls gl bittorrent valgrind llvm ibus
                     documentation sphinx imagemagick haskell-xyz spice inkscape
                     gimp kde tex password-utils freedesktop code qt glib file
                     libreoffice)

(packages->manifest
 (list
   alsa-plugins
   alsa-utils
   alsa-lib
   autogen
   ardour
   audacity
   ansible
   breeze-icons
   borg
   bridge-utils
   curl
   cairo
   clang
   devhelp
   doxygen
   dos2unix
   dconf-editor
   epiphany
   evolution
   evolution-data-server
   font-dejavu
   font-dseg
   font-google-noto
   font-adobe-source-han-sans
   fftw
   fftwf
   file
   fontconfig
   gnome-tweaks
   gnupg
   gcc-toolchain
   git
   ;gettext
   gdb
   ;glib-with-documentation
   glibc-locales
   ghc-pandoc
   gtk+
   ;gimp
   glfw
   glibc
   hexchat
   help2man
   htop
   icecat
   ibus-anthy
   ibus
   imagemagick
   inkscape
   jack-1
   jalv
   ;krita
   libyaml
   libsndfile
   libsamplerate
   libreoffice
   lv2
   lilv
   libvirt
   libosinfo
   libxt
   mpv
   ;make
   matcha-theme
   meson
   mesa
   ;ncdu
   nss-certs
   ninja
   network-manager-openvpn
   openssh
   openvpn
   openssl
   pkg-config
   perl
   pelican
   pinentry-gnome3
   python-babel
   pango
   portaudio
   portmidi
   python
   python-sphinx-intl
   python-libvirt
   python-sphinx
   pwgen
   python-polib
   python-feedparser
   qjackctl
   qemu
   quaternion
   quaternion
   qbittorrent
   qtbase
   rsync
   redshift
   rubberband
   suil
   serd
   sord
   sloccount
   tree
   tmux
   texlive-bin
   texlive-pstool
   texlive
   util-linux
   unzip
   vim
   valgrind
   virt-manager
   virt-viewer
   wget
   xdg-utils
   youtube-dl
   zsh
   zlib
   zip
   ;; Use a specific package output.
   (list gtk+ "doc")
   (list bind "utils")
   (list git "send-email")))
