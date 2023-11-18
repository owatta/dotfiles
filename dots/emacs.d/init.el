(require 'package)
(customize-set-variable 'package-archives
                        `(("melpa" . "https://melpa.org/packages/")
                          ,@package-archives))

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package emacs
  :bind ("C-h" . 'delete-backward-char)
  :custom
  (tool-bar-mode nil)
  (menu-bar-mode nil)
  (scroll-bar-mode nil)
  (cursor-type 'bar)
  (electric-pair-mode t)
  (sentence-end-double-space nil)
  (require-final-newline t)
  (frame-inhibit-implied-size t)
  (kill-whole-line t)
  (fringe-mode 50)
  :config
  (setq custom-file "/dev/null"))

(use-package files
  :hook
  (before-save . 'delete-trailing-whitespace)
  :custom
  (backup-by-copying t)
  (backup-directory-alist
   `((".*" . ,(locate-user-emacs-file "backups"))))
  (delete-old-versions t)
  (kept-new-versions 6)
  (kept-old-versions 2)
  (version-control t))

(use-package faces
  :custom-face
  (default ((t (:family "Fantasque Sans Mono" :height 135))))
  (mode-line ((t (:box (:line-width (10 . 8) :color "#000000" :style 'nil) :overline "dim grey"))))
  (mode-line-inactive ((t (:box (:line-width (10 . 8) :color "#000000" :style 'nil) :overline "dim grey"))))
;;  (mode-line ((t (:box (:line-width (10 . 8) :color "#e7e7e7" :style 'nil)))))
  )

(use-package doom-themes
  :straight t
;;  :custom-face
;;  (default ((t (:background "#ffffff"))))
  :config
  (load-theme 'doom-meltbus t))

(use-package orderless
  :straight t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion))))
  :config
  (defun flex-if-twiddle (pattern _index _total)
    (when (string-suffix-p "~" pattern)
      `(orderless-flex . ,(substring pattern 0 -1))))

  (defun first-initialism (pattern index _total)
    (if (= index 0) 'orderless-initialism))

  (defun without-if-bang (pattern _index _total)
    (cond
     ((equal "!" pattern)
      '(orderless-literal . ""))
     ((string-prefix-p "!" pattern)
      `(orderless-without-literal . ,(substring pattern 1)))))

  (setq orderless-matching-styles '(orderless-regexp)
	orderless-style-dispatchers '(first-initialism
                                      flex-if-twiddle
                                      without-if-bang)))

(use-package consult
  :straight t
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings in `mode-specific-map'
         ("C-c M-x" . consult-mode-command)
         ("C-c h" . consult-history)
         ("C-c k" . consult-kmacro)
         ("C-c m" . consult-man)
         ("C-c i" . consult-info)
         ([remap Info-search] . consult-info)
         ;; C-x bindings in `ctl-x-map'
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings in `goto-map'
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings in `search-map'
         ("M-s d" . consult-find)                  ;; Alternative: consult-fd
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window))

(use-package vertico
  :straight t
  :init
  (vertico-mode))

(use-package savehist
  :straight t
  :init
  (savehist-mode))

(use-package marginalia
  :straight t
  :bind (:map minibuffer-local-map
              ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package corfu
  :straight t
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-separator ?\s)          ;; Orderless field separator
  (corfu-scroll-margin 5)        ;; Use scroll margin

  ;; Enable Corfu only for certain modes.
  :hook ((prog-mode . corfu-mode)
         (shell-mode . corfu-mode)
         (eshell-mode . corfu-mode)
	 (comint-mode . corfu-mode)))

;; (use-package puni
;;   :straight t
;;   :hook ((prog-mode
;; 	  sgml-mode
;; 	  nxml-mode
;; 	  tex-mode
;; 	  eval-expression-minibuffer-setup
;; 	  lisp-mode) . puni-mode)
;;   :bind
;;   (:map puni-mode-map
;; 	("C-)" . puni-slurp-forward)
;; 	("C-}" . puni-barf-forward)
;; 	("C-(" . puni-slurp-backward)
;; 	("C-{" . puni-barf-backward)))

(use-package paredit
  :ensure t
  :hook ((lisp-mode . paredit-mode)
	 (emacs-lisp-mode . paredit-mode)
	 (scheme-mode . paredit-mode)))

(use-package sly
  :straight t)

(use-package nix-mode
  :straight t)

(use-package dired
  :custom
  (dired-kill-when-opening-new-dired-buffer t)
  :config
  (defun switch-to-monospace ()
    '(face-remap-add-relative 'default
					 :family "Fira Code"
                                         :height 1.0))
  :hook
  (dired-mode . switch-to-monospace))

(use-package embark
  :straight t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("M-." . embark-dwim))        ;; good alternative: M-.
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :straight t
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package haskell-mode
  :straight t)

(use-package flycheck
  :straight t
  :hook ((prog-mode . flycheck-mode)))

(use-package smooth-scrolling
  :straight t
  :config
  (smooth-scrolling-mode t))

(use-package good-scroll
  :straight t
  :config
  (good-scroll-mode t)
  (global-set-key [next] #'good-scroll-up-full-screen)
  (global-set-key [prior] #'good-scroll-down-full-screen))

;; epubs
(use-package nov
  :straight t
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
  (setq nov-unzip-args '("-xC" directory "-f" filename)))

(use-package elfeed
  :straight t)

(use-package olivetti
  :straight t)

;; TODO:
;; - popper
;; - reconfigure orderless
