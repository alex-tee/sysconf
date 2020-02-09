;; Add alextee/guix-packages
(define %github-channels
  ;; Default list of channels.
  (list (channel
         (name 'guix)
         (branch "master")
         ;; FIXME set back to
         ;; (url "https://github.com/guix-mirror/guix"))))
         (url "https://git.savannah.gnu.org/git/guix.git"))))

(cons (channel
  (name 'alextee-guix-packages)
  (url "https://git.zrythm.org/git/guix-repo"))
 %github-channels)
