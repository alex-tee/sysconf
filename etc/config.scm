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
         "guix gc -F 1G"))

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
  (locale-definitions
    (list (locale-definition (source "en_US")
                             (name "en_US.UTF-8"))
          (locale-definition (source "he_IL")
                             (name "he_IL.UTF-8"))))
  (timezone "Europe/London")
  (keyboard-layout
    (keyboard-layout "us" "altgr-intl"))
  (bootloader
    (bootloader-configuration
      (bootloader grub-efi-bootloader)
      (target "/boot/efi")
      (keyboard-layout keyboard-layout)))
  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "2f36cdf4-9042-40ca-9392-515f37d0e980"
                     'ext4))
             (type "ext4"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "011D-0C82" 'fat32))
             (type "vfat"))
           (file-system
             (mount-point "/home")
             (device
               (uuid "2c896a94-8a1c-417c-a447-818143bb4008"
                     'ext4))
             (type "ext4"))
           %base-file-systems))
  (host-name "alex-guix")
  (users (cons* (user-account
                  (name "alex")
                  (comment "alex")
                  (group "users")
                  (home-directory "/home/alex")
		              (shell (file-append bash "/bin/bash"))
                  (supplementary-groups
                    '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))
  (packages
    (append
      (map specification->package
	   '("nss-certs" "glib" "vim" "zsh" "mpv" "pkg-config"
	     "gnome-tweaks" "qjackctl" "util-linux" "alsa-plugins"
	     "alsa-utils" "hexchat" "jack" "pelican"
	     "pinentry-gnome3" "gnupg" "openssh" "rsync" "breeze-icons"
	     "meson" "ninja" "redshift" "quaternion" "devhelp" "borg"
	     "gcc-toolchain" "wget" "unzip" "openvpn" "tree" "autogen"
	     "git" "libyaml" "alsa-lib" "gtk+" "libsndfile" "libsamplerate"
	     "gettext" "fftw" "fftwf" "gdb" "calf" "curl" "zlib"
	     "glibc-locales" "cairo" "help2man" "fontconfig" "pango" "suil"
	     "ardour" "python" "lv2" "lilv" "serd" "sord" "gnome-screenshot"
	     "openssl" "htop" "mesa" "evolution" "network-manager-openvpn"))
      %base-packages))
  (services
    (append
      (list (service gnome-desktop-service-type)
            (service xfce-desktop-service-type)
            (service mate-desktop-service-type)
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
