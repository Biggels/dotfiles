;;; init.el --- My Custom Emacs Configuration

;; 1. PACKAGE MANAGEMENT SETUP
(require 'package)

;; Add MELPA (Community packages) to the list of repositories
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Initialize the package system
(package-initialize)

;; Setup 'use-package' (Built-in since Emacs 29)
;; This is a macro that makes installing plugins very clean
(require 'use-package)
(setq use-package-always-ensure t) ;; Always download if not present

;; 2. USER INTERFACE TWEAKS

;; Remove the visual noise
(setq inhibit-startup-message t)   ;; No splash screen
(scroll-bar-mode -1)               ;; No scrollbar
(tool-bar-mode -1)                 ;; No toolbar (the icons at the top)
(tooltip-mode -1)                  ;; No mouse tooltips
(menu-bar-mode -1)                 ;; No menu bar (press F10 if you need it later)
(set-fringe-mode 10)               ;; Add some breathing room on the sides

;; Quality of Life
(global-display-line-numbers-mode 1) ;; Show line numbers
(column-number-mode)                 ;; Show column number in the footer
(setq visible-bell t)                ;; Flash screen instead of beeping on errors

;; 3. ESSENTIAL PACKAGES

;; Which-Key: Shows a popup of available keybindings
(use-package which-key
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0.3)) ;; Popup shows up faster

;; Doom Themes: A nice set of themes
(use-package doom-themes
  :config
  ;; Load the theme (you can change 'doom-one' to 'doom-dracula', 'doom-nord', etc.)
  (load-theme 'doom-one t))

;; Rainbow Delimiters: Colors matching brackets () [] {} so you don't get lost
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; 4. BETTER COMPLETION (Menus & Search)

;; Vertico: Vertical completion UI
(use-package vertico
  :init
  (vertico-mode))

;; Orderless: Fuzzy searching (type parts of words to find matches)
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;; Marginalia: Rich annotations (descriptions) in the menu
(use-package marginalia
  :init
  (marginalia-mode))

;; 5. PROJECT MANAGEMENT & SEARCH

;; Projectile: Handles projects (git repos, etc.)
(use-package projectile
  :config
  (projectile-mode +1)
  ;; Recommended keymap prefix for Projectile is C-c p
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

;; Consult: Powerful search and navigation commands
(use-package consult
  :bind (;; A recursive grep (search text inside all files in a folder)
         ("C-s" . consult-line)           ;; Search inside the CURRENT file (better C-s)
         ("C-M-l" . consult-imenu)        ;; Jump to function/variable in file
         ("C-x b" . consult-buffer)))     ;; Better buffer switching (shows preview!)

;; 6. GIT INTEGRATION

;; Magit: The best Git client ever created
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(global-set-key (kbd "C-x g") 'magit-status)

;; 7. CUSTOM SHORTCUTS

;; Define a function to open the config file
(defun my/open-config ()
  "Open the init.el file."
  (interactive) ;; Makes it callable via M-x
  (find-file "~/.config/emacs/init.el"))

;; Bind it to 'C-c e' (Control-c, then e)
(global-set-key (kbd "C-c e") 'my/open-config)

;; 8. CODING UI (AUTO-COMPLETE)

;; Corfu: The popup completion interface
(use-package corfu
  ;; Optional customizations
  :custom
  (corfu-cycle t)                ;; Enable cycling for `corfu-next/previous'
  (corfu-auto t)                 ;; Enable auto completion
  (corfu-auto-delay 0.2)         ;; Delay before showing popup
  (corfu-auto-prefix 2)          ;; Number of characters before showing popup
  ;; Enable Corfu globally
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))        ;; Shows documentation

;; 9. LANGUAGE SERVER PROTOCOL (LSP)

;; Eglot: The built-in client for LSP
(use-package eglot
  :hook ((python-mode . eglot-ensure)   ;; Start Eglot for Python
         (c-mode . eglot-ensure)        ;; Start Eglot for C
         (c++-mode . eglot-ensure)      ;; Start Eglot for C++
         (rust-mode . eglot-ensure)))   ;; Start Eglot for Rust

;; 10. BETTER SYNTAX HIGHLIGHTING (Tree-Sitter)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt) ;; Ask to install grammar if missing
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))
