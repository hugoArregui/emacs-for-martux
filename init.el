;;; init.el --- Emacs configuration file

;; (defmacro measure-time (msg &rest body)
;;   "Measure the time it takes to evaluate BODY."
;;   `(let ((time (current-time)))
;;      (let ((r ,@body))
;;        (message "%s %.06f" ,msg (float-time (time-since time)))
;;        r)))

;; straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; No littering and use-package
(customize-set-variable 'package-enable-at-startup nil)

(straight-use-package 'no-littering)
(require 'no-littering)
(require 'recentf)
(add-to-list 'recentf-exclude no-littering-var-directory)
(add-to-list 'recentf-exclude no-littering-etc-directory)

(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))

(straight-use-package 'use-package)
(require 'package)
(add-to-list 'package-archives
             '("melpa"        . "https://melpa.org/packages/"))
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
             '("gnu"          . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives
             '("nongnu" . "https://elpa.nongnu.org/nongnu/"))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)

;; UI
;;; Remove tool bars
(tool-bar-mode -1)
(menu-bar-mode -1)

;;; Set theme and custom faces
(if (eq system-type 'gnu/linux)
    (set-face-attribute 'default nil
                        :font "JetBrains Mono"
                        :weight 'light
                        :height 83))

(straight-use-package 'doom-themes)
(add-to-list 'custom-theme-load-path (concat user-emacs-directory "themes"))
(customize-set-variable 'my-doom-vibrant-brighter-comments t)
(customize-set-variable 'my-doom-vibrant-brighter-modeline t)

  ;;; highlight TODO, NOTE, IMPORTANT
(defface font-lock-fixme-face
  '((t
     :foreground "Orange Red" :underline t :italic t))
  "TODO/FIXME highlight face")

(defface font-lock-important-face
  '((t
     :foreground "Yellow" :underline t :italic t))
  "IMPORTANT highlight face")

(defface font-lock-note-face
  '((t
     :foreground "Green" :underline t :italic t))
  "NOTE highlight face")

(add-hook 'prog-mode-hook
          '(lambda ()
             (font-lock-add-keywords
              major-mode
              '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
                ("\\<\\(FIXME\\)" 1 'font-lock-fixme-face t)
                ("\\<\\(IMPORTANT\\)" 1 'font-lock-important-face t)
                ("\\<\\(NOTE\\)" 1 'font-lock-note-face t)))))


;;;  Modeline
(straight-use-package 'all-the-icons)

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-minor-modes t)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)

  (doom-modeline-height 15))

(straight-use-package 'diminish) ;hides pesky minor modes from the modelines.

;; Load sensible defaults
(load-file (concat user-emacs-directory "modules/sensible-defaults.el"))

(sensible-defaults/use-all-keybindings)
(sensible-defaults/open-files-from-home-directory)
(sensible-defaults/increase-gc-threshold)
(sensible-defaults/delete-trailing-whitespace)
(sensible-defaults/treat-camelcase-as-separate-words)
(sensible-defaults/automatically-follow-symlinks)
(sensible-defaults/make-scripts-executable)
(sensible-defaults/single-space-after-periods)
(sensible-defaults/offer-to-create-parent-directories-on-save)
(sensible-defaults/apply-changes-to-highlighted-region)
(sensible-defaults/overwrite-selected-text)
(sensible-defaults/ensure-that-files-end-with-newline)
(sensible-defaults/confirm-closing-emacs)
(sensible-defaults/quiet-startup)
(sensible-defaults/make-dired-file-sizes-human-readable)
(sensible-defaults/shorten-yes-or-no)
(sensible-defaults/always-highlight-code)
(sensible-defaults/refresh-buffers-when-files-change)
(sensible-defaults/flash-screen-instead-of-ringing-bell)
(sensible-defaults/set-default-line-length-to 80)
(sensible-defaults/open-clicked-files-in-same-frame-on-mac)
(sensible-defaults/yank-to-point-on-mouse-click)

;; Evil
(straight-use-package 'evil)
(straight-use-package 'evil-collection)
(straight-use-package 'undo-tree)
(straight-use-package 'evil-leader)
(straight-use-package 'evil-visualstar) ;; Search with * and #
(straight-use-package 'evil-numbers)
(straight-use-package 'evil-search-highlight-persist)

(global-undo-tree-mode)

;; Set some variables that must be configured before loading the package
(customize-set-variable 'evil-want-integration t)
(customize-set-variable 'evil-want-keybinding nil)
(customize-set-variable 'evil-want-C-u-scroll t)
(customize-set-variable 'evil-respect-visual-line-mode t)
(customize-set-variable 'evil-undo-system 'undo-tree)

;; (setq evil-search-module 'evil-search) ; before the require
;; * and # search for words, not symbols
(customize-set-variable 'evil-symbol-word-search t)

;; Fine undo for evil-mode instead of one undo per insert.
(customize-set-variable 'evil-want-fine-undo t)

(customize-set-variable 'evil-leader/in-all-states 1)

(global-evil-leader-mode)
(evil-leader/set-leader ",")

(evil-collection-init 'magit)
(evil-collection-init 'ivy)
(evil-collection-init 'company)
(evil-collection-init 'dired)
;; (evil-collection-init 'custom)

(require 'evil)
(evil-mode 1)

(global-evil-visualstar-mode)

(define-key evil-normal-state-map (kbd "C-a")
  'evil-numbers/inc-at-pt)

(define-key evil-normal-state-map (kbd "C-z")
  'evil-numbers/dec-at-pt)

(global-evil-search-highlight-persist t)

(define-key evil-normal-state-map (kbd "L") 'evil-end-of-line)
(define-key evil-normal-state-map (kbd "H") 'evil-first-non-blank)
(define-key evil-visual-state-map (kbd "L") 'evil-end-of-line)
(define-key evil-visual-state-map (kbd "H") 'evil-first-non-blank)
(define-key evil-normal-state-map (kbd "gs") 'newline-and-indent)

(evil-leader/set-key
  "h"  'evil-search-highlight-persist-remove-all)

(define-key evil-normal-state-map (kbd "C-w b")
  'switch-to-buffer-other-window)

(define-key evil-normal-state-map (kbd "gS")
  (lambda ()
    (interactive)
    (save-excursion
      (forward-char)
      (newline-and-indent))))

(define-key evil-normal-state-map (kbd "<up>") 'previous-error)
(define-key evil-normal-state-map (kbd "<down>") 'next-error)
(define-key evil-normal-state-map (kbd "gr") 'recompile)

;;; Make Messages buffer work
(with-eval-after-load 'evil-leader
  (add-hook 'after-init-hook
            (lambda (&rest _)
              (when-let ((messages-buffer (get-buffer "*Messages*")))
                (with-current-buffer messages-buffer
                  (evil-normalize-keymaps)
                  (evil-leader-mode))))))

;;; Use key-chord for "jj"
(straight-use-package 'key-chord)
(customize-set-variable 'key-chord-two-keys-delay 0.5)
(key-chord-mode 1)
(key-chord-define evil-insert-state-map "jj" 'evil-normal-state)

;;; Evil matchit: press "%" to jump between matched tags
(straight-use-package 'evil-matchit)
(defun evilmi-customize-keybinding ()
  (evil-define-key 'normal evil-matchit-mode-map (kbd "<tab>")
    'evilmi-jump-items))
(global-evil-matchit-mode 1)


;;; ESC quits everywhere
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
  In Delete Selection mode, if the mark is active, just deactivate it;
  then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*")
      (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

(define-key evil-normal-state-map [escape]
  'keyboard-quit)
(define-key evil-visual-state-map [escape]
  'keyboard-quit)
(define-key minibuffer-local-map [escape]
  'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape]
  'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape]
  'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape]
  'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape]
  'minibuffer-keyboard-quit)

;;; Relative line numbers
(straight-use-package 'nlinum-relative)
(nlinum-relative-setup-evil)
(add-hook 'prog-mode-hook 'nlinum-relative-mode)

;; Projectile, Ivy + Counsel
(straight-use-package 'projectile)
(straight-use-package 'ivy)
(straight-use-package 'counsel)
(straight-use-package 'counsel-projectile)

;; I use smex so counsel-M-x is order by recent first
(straight-use-package 'smex)

(require 'projectile)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)

(ivy-mode 1)

(customize-set-variable 'projectile-completion-system 'ivy)
(customize-set-variable 'ivy-use-virtual-buffers t)
(customize-set-variable 'ivy-count-format "(%d/%d) ")

(global-set-key (kbd "M-x") 'counsel-M-x)

(counsel-projectile-mode)

(evil-leader/set-key
  "v"  'ivy-switch-buffer
  "f"  'counsel-find-file
  "F"  'counsel-projectile-find-file
  "g"  'projectile-grep)

;; Org Mode
(straight-use-package 'org)
(straight-use-package 'org-contrib)

(defun org-mode-setup ()
  "My org mode setup."
  (org-indent-mode)
  (org-superstar-mode)
  (require 'org-element)
  (evil-define-text-object
    evil-org-element (count &optional beg end type)
    "Select an org element ."
    :extend-selection nil
    (let ((current-elem (org-element-context)))
      (let ((beg (org-element-property :begin current-elem))
            (end(org-element-property :end current-elem)))
        (evil-range beg end))))

  (define-key evil-outer-text-objects-map "e"
    'evil-org-element)

  (define-key evil-inner-text-objects-map "e"
    'evil-org-element))

(use-package org
  :ensure nil
  :hook (org-mode . org-mode-setup)
  :config

  (add-hook 'org-capture-mode-hook 'evil-insert-state))

(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . evil-org-mode)
  :init

  (require 'evil-org)

  (evil-org-set-key-theme '(navigation todo insert textobjects additional)))

(require 'org)

(straight-use-package 'org-superstar)
(customize-set-variable 'org-fontify-quote-and-verse-blocks t)
(customize-set-variable 'org-refile-targets '((org-agenda-files :level . 1)))
(customize-set-variable 'org-use-property-inheritance t)
(customize-set-variable 'org-startup-folded t)
(customize-set-variable 'org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●"))

;;; scale org mode's latex fragments preview.
(customize-set-variable 'org-format-latex-options (plist-put org-format-latex-options :scale 2.5))

(evil-leader/set-key
  "c"  'org-capture

  "ts"  'org-timer-set-timer
  "tp" 'org-timer-pause-or-continue)

;;; Structure templates
(with-eval-after-load 'org
  ;; This is needed as of Org 9.2
  (require 'org-tempo)

  (add-to-list 'org-structure-template-alist '("sh" . "src shell"))
  (add-to-list 'org-structure-template-alist '("el" . "src elisp"))
  (add-to-list 'org-structure-template-alist '("py" . "src python")))

;; Org Roam
(straight-use-package 'org-roam)
(customize-set-variable 'org-roam-directory "~/workspace/docs/zettel")
(customize-set-variable 'org-roam-db-location "~/tmp/roam/org-roam.db")

(customize-set-variable 'org-roam-completion-everywhere t)
(customize-set-variable 'org-roam-db-location "~/tmp/roam/org-roam.db")
(customize-set-variable 'org-roam-directory "~/workspace/docs/zettel")
(customize-set-variable 'org-roam-node-display-template "${title:*} ${tags:50}")

(org-roam-db-autosync-mode)
(require 'org-roam)
(require 'org-roam-protocol)

(evil-leader/set-key
  "rc" 'org-roam-capture
  "rb" 'org-roam-buffer-toggle
  "rf" 'org-roam-node-find
  "rg" 'org-roam-graph
  "rdt" 'org-roam-dailies-capture-today
  "rdp" 'org-roam-dailies-goto-previous-note
  "rdn" 'org-roam-dailies-goto-next-note)

(evil-leader/set-key-for-mode
  'org-mode
  "ri" 'org-roam-node-insert)

;; Org Agenda
(require 'org-agenda)
(use-package org-super-agenda
  :ensure t
  :init
  (setq org-super-agenda-groups
        '(;
          (:name "Events"
                 :not (:tag "HABIT"))
          (:name "Soul Habits"
                 :and (:tag "HABIT" :tag "SOUL"))
          (:name "Bodily Habits"
                 :and (:tag "HABIT" :tag "BODY"))
          (:name "External Habits"
                 :and (:tag "HABIT" :tag "EXTERNAL"))
          (:name "Uncategorized Habits"
                 :tag "HABIT")
          ;; After the last group, the agenda will display items that didn't
          ;; match any of these groups, with the default order position of 99
          ))
  (org-super-agenda-mode))

(add-hook 'org-agenda-mode-hook
          (lambda ()
            (define-key org-super-agenda-header-map "j" 'evil-next-line)
            (define-key org-super-agenda-header-map "k" 'evil-previous-line)
            (define-key org-agenda-mode-map "j" 'evil-next-line)
            (define-key org-agenda-mode-map "k" 'evil-previous-line)))

(add-hook 'org-agenda-finalize-hook (lambda () (hl-line-mode)))

(setq org-todo-keyword-faces
      '(("DONE" . (:foreground "white" :weight bold))
        ("CANCELED" . (:foreground "white" :weight bold))))

(customize-set-variable 'org-agenda-start-on-weekday nil)
(customize-set-variable 'org-agenda-span 7)
(customize-set-variable 'org-log-into-drawer "LOGBOOK")
(customize-set-variable 'org-refile-targets (quote ((org-agenda-files :level . 1))))
(customize-set-variable 'org-refile-use-outline-path  'file)
(customize-set-variable 'org-refile-allow-creating-parent-nodes 'confirm)
(customize-set-variable 'org-habit-graph-column 50)
(customize-set-variable 'org-agenda-repeating-timestamp-show-all nil)
(customize-set-variable 'org-cycle-separator-lines 0)

(defcustom org-custom-habit-show-habits t
  "If non-nil, show habits in agenda buffers."
  :group 'org-custom-habit
  :type 'boolean)

(defun org-agenda-toggle-custom-habits ()
  "Toggle display of custom habits in an agenda buffer."
  (interactive)
  (org-agenda-check-type t 'agenda)
  (setq org-custom-habit-show-habits (not org-custom-habit-show-habits))
  (if org-custom-habit-show-habits
      (org-agenda-filter-by-tag "-HABIT" ?\s)
    (org-agenda-filter-show-all-tag))
  (org-agenda-redo))

(org-defkey org-agenda-mode-map "H" 'org-agenda-toggle-custom-habits)

(defun org-agenda-cmp-time-of-day-first (a b)
  (let* ((a-tod (get-text-property 0 'time-of-day a))
         (b-tod (get-text-property 0 'time-of-day b))
         (cmp (cond ((eq a-tod nil) -1)
                    ((eq b-tod nil) 1)
                    (t              nil))))
    cmp
    ))

(customize-set-variable 'org-agenda-cmp-user-defined 'org-agenda-cmp-time-of-day-first)
(evil-leader/set-key
  "a"  'org-agenda)

;; Elfeed
(setq elfeed-search-filter "@1-months-ago +unread")

(defun elfeed-set-default-filter ()
  (interactive)
  (setq elfeed-search-filter "@1-months-ago +unread")
  (elfeed-search-update :force))

(use-package elfeed
  :ensure    t
  :custom ((rmh-elfeed-org-files (list (concat user-emacs-directory "elfeed.org"))))
  :config
  (evil-collection-init 'elfeed)

  (evil-collection-define-key 'normal 'elfeed-search-mode-map
    "gh" 'elfeed-set-default-filter))


(use-package elfeed-org
  :ensure    t
  :init
  (require 'elfeed-org)
  (elfeed-org))

(evil-leader/set-key
  "e"  'elfeed)

;; Magit
(use-package magit
  :ensure t
  :custom ((evil-collection-magit-use-z-for-folds t))
  :config

  (add-to-list 'magit-section-initial-visibility-alist '(unpushed . show))
  (evil-ex-define-cmd "Gstatus" 'magit-status))

;; Flycheck

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(use-package flycheck-pos-tip
  :ensure t
  :after flycheck
  :config
  (flycheck-pos-tip-mode))

;; Ledger
(straight-use-package 'ledger-mode)
(straight-use-package 'flycheck-ledger)
(straight-use-package 'evil-ledger)
(customize-set-variable 'evil-ledger-sort-key "S")
(add-hook 'ledger-mode-hook #'evil-ledger-mode)

;; Window management
(straight-use-package 'popwin)
(popwin-mode 1)

;; Environment Variables: Ensure environment variables inside Emacs look the same as in the user's shell.
(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

;; Company
(use-package company
  :ensure t
  :config
  (setq company-idle-delay 0.2)
  (setq company-minimum-prefix-length 1)
  (setq company-show-quick-access t)
  (setq company-tooltip-limit 20)
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-ignore-case t)
  (setq company-dabbrev-code-ignore-case t)
  (setq company-dabbrev-code-everywhere t)
  ;; (setq company-etags-ignore-case t)

  (setq company-tooltip-align-annotations t)

  (setq company-global-modes '(not eshell-mode))
  (global-company-mode))

;;; Company-box provides a nicer UI for company completion
(use-package company-box
  :ensure t
  :hook (company-mode . company-box-mode))

;; Editing
;;; Show parentheses
(show-paren-mode 1)

;;; Wrap text
(straight-use-package 'visual-fill-column)
(add-hook 'text-mode-hook #'visual-fill-column-mode)

;; (define-minor-mode my-fill-mode nil nil nil nil
;;   (when (and buffer-file-name (not buffer-read-only))
;;     (whitespace-mode -1)
;;     (setq whitespace-style
;;           (append '(face trailing)
;;                   (and my-fill-mode (not (eq major-mode 'org-mode))
;;                        '(lines-tail))))
;;     (whitespace-mode))
;;   (visual-line-mode (when my-fill-mode -1))
;;   (visual-fill-column-mode (when my-fill-mode -1))
;;   (auto-fill-mode (unless my-fill-mode -1)))

;; (add-hook 'text-mode-hook 'my-fill-mode)


;; Rainbow delimiters
(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

;; Indentation
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default evil-shift-width tab-width)

(defun align-to-equals (begin end)
  "Align region (BEGIN END) to equal signs."
  (interactive "r")
  (align-regexp begin end "\\(\\s-*\\)=" 1 1))

(customize-set-variable 'js-indent-level 2)
(customize-set-variable 'sh-basic-offset 2)
(customize-set-variable 'sh-indentation 2)

;; dtrt-indent tries to guess indentation for a file
(use-package dtrt-indent
  :ensure t
  :config
  (dtrt-indent-mode 1))

;; Dired
(use-package dired
  ;; From https://github.com/daviwil/emacs-from-scratch/blob/master/Emacs.org#dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first"))
  :config
  (setq dired-guess-shell-alist-user '(("\\.pdf\\'" "zathura")
                                       ("\\.epub\\'" "zathura")))
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-single-up-directory
    "l" 'dired-single-buffer))

(use-package dired-single
  :ensure t
  :commands (dired dired-jump))

(use-package diredfl
  :ensure t
  :hook (dired-mode . diredfl-mode))

(use-package all-the-icons-dired
  :ensure t
  :hook (dired-mode . all-the-icons-dired-mode))

;; Contacts
(require 'org-contacts)
(customize-set-variable 'org-contacts-files '("~/workspace/docs/agenda/contacts.org"))

;; Programming

;;; LSP (Language Server Protocol)
(use-package lsp-mode
  :ensure t
  :init
  (setq lsp-keymap-prefix "C-c l")
  :commands lsp)

(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)

(use-package lsp-ui
  :ensure t
  :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-show-hover nil)
  (setq lsp-ui-doc-position 'bottom)
  (lsp-ui-doc-show))

;;; Syntax checking
(use-package flycheck
  :defer t
  :hook (lsp-mode . flycheck-mode))

;;; Go
(use-package go-mode
  :ensure t
  :hook (go-mode . lsp-deferred))

;;; Generic function text object
(evil-define-text-object
  evil-generic-function (count &optional beg end type)
  "Select a function."
  :extend-selection nil
  (let ((beg
         (save-excursion
           (beginning-of-defun)
           (point)))
        (end
         (save-excursion
           (end-of-defun)
           (point))))
    (evil-range beg end)))

(add-hook 'prog-mode-hook
          '(lambda ()
             (define-key evil-outer-text-objects-map "f"
               'evil-generic-function)
             (define-key evil-inner-text-objects-map "f"
               'evil-generic-function)))

;;; Dockerfile
(use-package dockerfile-mode
  :mode "Dockerfile\\'"
  :ensure t)

;;; YAML
(use-package yaml-mode
  :ensure t
  :mode "\\.yml\\'")

;; Yasnippet
(use-package yasnippet
  :ensure t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))

;; Load custom file and enable theme
(let ((custom-file (concat user-emacs-directory "custom.el")))
  (load custom-file :noerror))

;;; not sure, but I think I need to enable it after the custom file because it should be set as "safe"
(load-theme 'my-doom-vibrant t)
