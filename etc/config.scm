(use-modules (gnu)
       (guix)
       (gnu services mcron)
       (gnu system locale))
(use-service-modules dbus sound vpn desktop networking ssh xorg
         shepherd virtualization)
(use-package-modules audio bash shells linux glib)

(define garbage-collector-job
  ;; Collect garbage 1 minutes after midnight every day.
  ;; The job's action is a shell command.
  #~(job "1 0 * * *"            ;Vixie cron syntax
         "guix pull && guix upgrade && guix gc -F 1G"))

(define borg-backup-job
  ;; Run the backup script 5 minutes after midnight every day
  ;; This runs from the user's home directory.
  #~(job "5 0 * * *"            ;Vixie cron syntax
    "~/bin/backup_system.sh"
         #:user "alex"))

(define special-file-service
  (service special-files-service-type
     `(("/bin/sh" ,(file-append bash "/bin/sh"))
       ("/bin/pwd" ,(file-append coreutils "/bin/pwd"))
       ("/bin/bash" ,(file-append bash "/bin/bash"))
       ("/lib64" ,(file-append glibc "/lib"))
       ("/usr/bin/env" ,(file-append coreutils "/bin/env")))))

(operating-system
  (locale "en_GB.utf8")
  (timezone "Europe/London")
  (keyboard-layout (keyboard-layout "us" "mac"))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (swap-devices (list "/dev/sda3"))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "474736e5-18b3-446d-b080-7f1ee3049d29"
                     'ext4))
             (type "ext4"))
           (file-system
             (mount-point "/home")
             (device
               (uuid "2c896a94-8a1c-417c-a447-818143bb4008"
                     'ext4))
             (type "ext4"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "6B6C-8FE5" 'fat32))
             (type "vfat"))
           %base-file-systems))
  (host-name "alex-guix")
  (users (cons* (user-account
                  (name "alex")
                  (comment "alex")
                  (group "users")
                  (home-directory "/home/alex")
                  (shell (file-append bash "/bin/bash"))
                  (supplementary-groups
                    '("wheel" "libvirt" "kvm" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (map specification->package+output
     '("nss-certs" "vim" "zsh" "mpv" "pkg-config" "perl" "icecat"
       "gnome-tweaks" "qjackctl" "util-linux" "alsa-plugins" "epiphany"
       "alsa-utils" "hexchat" "jack" "qemu" "pelican" "matcha-theme"
       "pinentry-gnome3" "gnupg" "openssh" "rsync" "breeze-icons"
       "meson" "ninja" "redshift" "quaternion" "devhelp" "borg" "make"
       "gcc-toolchain" "wget" "unzip" "openvpn" "tree" "autogen" "python-babel"
       "font-dejavu" "font-google-noto" "font-adobe-source-han-sans"
       "git" "libyaml" "alsa-lib" "libsndfile" "libsamplerate" "tmux"
       "gettext" "fftw" "fftwf" "gdb" "curl" "zlib" "quaternion"
       "glibc-locales" "cairo" "help2man" "fontconfig" "pango" "suil"
       "ardour" "python" "lv2" "lilv" "serd" "sord" "gnome-screenshot"
       "openssl" "htop" "mesa" "evolution" "network-manager-openvpn"
       "qbittorrent" "zip" "jalv" "valgrind" "clang" "libvirt" "ibus-anthy"
       "ibus" "doxygen" "bridge-utils" "youtube-dl" "ansible" "python-sphinx-intl"
       "python-libvirt" "imagemagick" "python-sphinx" "ghc-pandoc" "gtk+:doc"
       "virt-manager" "virt-viewer" "libosinfo" "inkscape" "gimp" "krita"
       "texlive-bin" "texlive-pstool" "texlive" "glfw" "dconf-editor"
       "pwgen" "xdg-utils"
       "python-polib" "python-feedparser"))
      %base-packages))
  (services
    (append
      (list (service gnome-desktop-service-type)
            (service xfce-desktop-service-type)
            (service tor-service-type)
      (service libvirt-service-type
              (libvirt-configuration
                (unix-sock-group "libvirt")
                (log-level 2)
                (tls-port "16555")))
      (service virtlog-service-type
               (virtlog-configuration
                 (max-clients 1000)))
      (set-xorg-configuration
        (xorg-configuration
          (keyboard-layout keyboard-layout)))
      ;; this service provides symlinks for programs in standard locations
      ;; (eg /bin/bash)
      (service special-files-service-type
         `(("/bin/sh" ,(file-append bash "/bin/sh"))
           ("/bin/pwd" ,(file-append coreutils "/bin/pwd"))
           ("/bin/bash" ,(file-append bash "/bin/bash"))
           ("/usr/bin/env" ,(file-append coreutils "/bin/env"))))
      (pam-limits-service
        (list
          (pam-limits-entry "@audio" 'both 'rtprio 99)
          (pam-limits-entry "@audio" 'both 'memlock 'unlimited)))
      (service mcron-service-type
               (mcron-configuration
                 (jobs (list garbage-collector-job
                             borg-backup-job)))))
      %desktop-services)))
