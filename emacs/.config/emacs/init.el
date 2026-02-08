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
(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;; Start maximized

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

;; Icons for the modeline and dired
(use-package nerd-icons)
(use-package nerd-icons-dired
  :hook
  (dired-mode . nerd-icons-dired-mode))

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

(use-package consult
  ;; Enable lazy loading: load the package when we use a command
  :bind (;; A recursive grep (search text inside all files in a folder)
         ("M-s r" . consult-ripgrep)      ;; Search for text in project (Ripgrep)
         
         ;; C-s is normally "isearch", but consult-line is much better
         ("C-s" . consult-line)           ;; Search inside the CURRENT file 
         
         ;; C-M-l usually jumps to code, but consult-imenu shows a list
         ("C-M-l" . consult-imenu)        ;; Jump to function/variable in file
         
         ;; C-x b usually switches buffer, but consult-buffer shows previews
         ("C-x b" . consult-buffer))      ;; Better buffer switching
  
  :hook (completion-list-mode . consult-preview-at-point-mode)
  
  :init
  ;; Optionally configure the register formatting. This improves the register 
  ;; preview for `consult-register`, `consult-register-load`, etc.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref))

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
;;  (corfu-auto-prefix 2)          ;; Number of characters before showing popup
  ;; Enable Corfu globally
  :init
  (global-corfu-mode)
  (corfu-popupinfo-mode))        ;; Shows documentation

;; 9. LANGUAGE SERVER PROTOCOL (LSP)

;; Eglot: The built-in client for LSP
(use-package eglot
  :hook (;; PYTHON
         (python-mode . eglot-ensure)       ;; Standard
         (python-ts-mode . eglot-ensure)    ;; Tree-Sitter

         ;; C / C++
         (c-mode . eglot-ensure)
         (c-ts-mode . eglot-ensure)         ;; Tree-Sitter
         (c++-mode . eglot-ensure)
         (c++-ts-mode . eglot-ensure)       ;; Tree-Sitter

         ;; RUST
         (rust-mode . eglot-ensure)
         (rust-ts-mode . eglot-ensure)))    ;; Tree-Sitter

;; 10. BETTER SYNTAX HIGHLIGHTING (Tree-Sitter)

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt) ;; Ask to install grammar if missing
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; 11. MODELINE
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom
  (doom-modeline-height 35)      ;; How tall the bar is
  (doom-modeline-bar-width 4)    ;; How thick the corner bar is
  (doom-modeline-hud t))         ;; Show a visual scroll bar

;; 12. PYTHON VIRTUAL ENVIRONMENTS
(use-package pyvenv
  :config
  (pyvenv-mode 1)) ;; Enable it globally

;; AUTOMATION: 1. Auto-activate venv
(defun my/auto-activate-venv ()
  "Activate .venv or venv if found in the project root."
  (interactive)
  ;; FORCE Projectile to load so we can use its functions
  (require 'projectile) 
  
  (let* ((root (projectile-project-root))
         ;; Check for both standard names: ".venv" and "venv"
         (venv-path (or (and root (expand-file-name ".venv" root))
                        (and root (expand-file-name "venv" root)))))
    
    (when (and venv-path (file-exists-p venv-path))
      (pyvenv-activate venv-path)
      (message "Activated virtual environment at %s" venv-path))))

;; Run this check whenever we open a Python file
(add-hook 'python-mode-hook 'my/auto-activate-venv)
(add-hook 'python-ts-mode-hook 'my/auto-activate-venv)

;; AUTOMATION: 2. Auto-restart Eglot
(add-hook 'pyvenv-post-activate-hooks
          (lambda ()
            (when (bound-and-true-p eglot--managed-mode)
              (eglot-reconnect))))
