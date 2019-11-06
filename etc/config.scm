(use-modules (gnu))
(use-service-modules desktop networking ssh xorg)
(use-modules (gnu packages bash))
(use-modules (gnu packages shells))
(use-modules (gnu packages linux))
(use-modules (gnu services sound))
(use-modules (guix) (gnu) (gnu services mcron))

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

(operating-system
  (locale "en_GB.utf8")
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
      (list (specification->package "nss-certs"))
      %base-packages))
  (services
    (append
      (list (service gnome-desktop-service-type)
            (service xfce-desktop-service-type)
            (service mate-desktop-service-type)
            (set-xorg-configuration
              (xorg-configuration
                (keyboard-layout keyboard-layout)))
	    (pam-limits-service
	      (list
		      (pam-limits-entry "@audio" 'both 'rtprio 99)
		      (pam-limits-entry "@audio" 'both 'memlock 'unlimited)))
	    (service mcron-service-type
        (mcron-configuration
          (jobs (list garbage-collector-job
					            borg-backup-job)))))
      %desktop-services)))
