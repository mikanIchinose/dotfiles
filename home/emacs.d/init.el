;;; init.el --- My init.el auto-generated by leaf-manager  -*- lexical-binding: t; -*-

;; Copyright (C) 2020-2022 Yoshihiro Ichinose

;; Author: Yoshihiro Ichinose <maruisansmai at gmail.com>

;;; Commentary:

;; My init.el auto-generated by leaf-manager.

;;; Code:

(when (or load-file-name byte-compile-current-file)
      (setq user-emacs-directory (expand-file-name
                                  (file-name-directory
                                   (or load-file-name byte-compile-current-file)))))
(eval-and-compile
  (prog1 "setup straight.el"
    (defvar bootstrap-version)
    (let ((bootstrap-file (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
          (bootstrap-version 5))
      (unless (file-exists-p bootstrap-file)
        (with-current-buffer (url-retrieve-synchronously "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el" 'silent 'inhibit-cookies)
          (goto-char (point-max))
          (eval-print-last-sexp)))
      (load bootstrap-file nil 'nomessage)))
  (prog1 "install leaf"
    (straight-use-package 'leaf)

    ;; set useful keywords
    (straight-use-package 'leaf-keywords)
    (straight-use-package 'blackout)
    (straight-use-package 'hydra)
    (leaf-keywords-init))
  )

(leaf leaf-manager
  :straight t)

(leaf init-loader
  :doc "Loader for configuration files"
  :req "cl-lib-0.5"
  :url "https://github.com/emacs-jp/init-loader/"
  :added "2022-01-23"
  :straight t
  :require t
  :config
  (init-loader-load "~/.emacs.d/conf"))

(provide 'init)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("c4063322b5011829f7fdd7509979b5823e8eea2abf1fe5572ec4b7af1dd78519" default))
 '(evil-org-key-theme '(insert textobjects additional calender)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit outline-1 :height 1.2))) nil "Customized with leaf in `org-superstar' block at `/Users/solenoid/.emacs.d/conf/21_org.el'")
 '(org-level-2 ((t (:inherit outline-2 :height 1.15))) nil "Customized with leaf in `org-superstar' block at `/Users/solenoid/.emacs.d/conf/21_org.el'")
 '(org-level-3 ((t (:inherit outline-3 :height 1.1))) nil "Customized with leaf in `org-superstar' block at `/Users/solenoid/.emacs.d/conf/21_org.el'"))
 ;; Local Variables:
;; indent-tabs-mode: nil
;; buffer-read-only: nil
;; End:

;;; init.el ends here
