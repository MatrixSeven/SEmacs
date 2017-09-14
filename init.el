(require 'package)
(setq package-enable-at-startup nil)

(setq package-archives
      '(("gnu-cn" . "http://elpa.zilongshanren.com/gnu/")
        ("melpa-cn" . "http://elpa.zilongshanren.com/melpa/")
        ("melpa-stable-cn" . "	http://elpa.zilongshanren.com/melpa-stable/")
        ("marmalade-cn" . "http://elpa.zilongshanren.com/marmalade/")
        ("org-cn" . "http://elpa.zilongshanren.com/org/")))
(package-initialize)


;; -----------------------------------------------------------------------------
;; Use Package
;; -----------------------------------------------------------------------------

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;;默认文件编码
(prefer-coding-system 'utf-8)

;;修改mac的comm按键为super
(setq mac-command-modifier 'super)

;;设置各种文件编码
(setq buffer-file-coding-system 'utf-8-unix
      default-file-name-coding-system 'utf-8-unix
      default-keyboard-coding-system 'utf-8-unix
      default-process-coding-system '(utf-8-unix . utf-8-unix)
      default-sendmail-coding-system 'utf-8-unix
      default-terminal-coding-system 'utf-8-unix)

;;设置鼠标滚动
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))
      mouse-wheel-progressive-speed nil
      mouse-wheel-follow-mouse 't)


;;替换yes/no为y/n
(fset 'yes-or-no-p 'y-or-n-p)

(setq-default indent-tabs-mode nil)

;;关闭不需要的组件
(global-auto-revert-mode 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

;;-------------------------------------------------
;;绑定自定义快加减
;;-------------------------------------------------

;; C-x 2 | 3
;; C-x 1 current
;; C-x 0 close current
;; C-x o

;; C-g quit
;; C-h f  function -> key
;; C-h k  key -> function
(bind-key "s-o" 'find-file global-map)
(bind-key "s-s" 'save-buffer global-map)
(bind-key "s-c" 'kill-ring-save global-map)
(bind-key "s-v" 'yank global-map)
(bind-key "s-x" 'kill-region global-map)
(bind-key "s-e" 'switch-to-buffer global-map)
(bind-key "s-w" 'kill-buffer global-map)
(bind-key "<escape>" 'keyboard-escape-quit global-map)


;;项目管理
(use-package projectile
  :ensure t
  :init
  (projectile-mode))


(use-package counsel
  :ensure t
  :bind
  (("C-c g" . counsel-git)
   ("C-c G" . counsel-git-grep)
   ("C-c C-s" . swiper)
   ("C-c m" . counsel-imenu)
   ("C-c A" . counsel-ag)
   :map ivy-minibuffer-map
   ("<tab>" . ivy-alt-done)
   ("<escape>" . minibuffer-keyboard-quit)
   ("C-r" . counsel-expression-history)))

(use-package counsel-projectile
  :ensure t 
  :init
  (setq projectile-completion-system 'ivy)
  (counsel-projectile-on))



;;补全
(use-package ivy
  :ensure t
  :init
  (ivy-mode 1))

;;目录树
(use-package neotree
  :ensure t
  :bind
  (("s-\\" . neotree-toggle)))
;;主题
(use-package zenburn-theme
  :ensure t
  :init
  (load-theme 'zenburn t))


;;括号
(use-package paredit
  :ensure t
  :init
  (add-hook 'clojure-mode-hook 'paredit-mode)
  (add-hook 'cider-repl-mode-hook 'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode))

;;clojure支持
(use-package clojure-mode
  :ensure t)

;;clojure repl支持
(use-package cider
  :ensure t
  :bind
  (:map cider-mode-map
        ("C-c <tab>" . cider-inspect-last-result))
  :init
  (setq cider-prompt-for-symbol nil)
  (setq cider-lein-command "/usr/local/bin/lein"))

;;命令修复
(use-package exec-path-from-shell
  :ensure t
  :init
  (exec-path-from-shell-initialize))

(use-package aggressive-indent
  :ensure t
  :init
  (add-hook 'clojure-mode-hook 'aggressive-indent-mode)
  (add-hook 'clojure-repl-mode-hook 'aggressive-indent-mode)
  (add-hook 'emacs-lisp-mode-hook 'aggressive-indent-mode))
;;切换窗口
(use-package ace-window
  :ensure t
  :bind
  (("C-x C-x" . ace-window))
  :init
  (setq aw-keys '(?a ?o ?e ?u ?i ?d ?h ?t ?n)))

;;彩虹括号
(use-package rainbow-delimiters
  :ensure t
  :init
  (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode))

;;远程nrepl
(use-package monroe
  :ensure t)

;;git修改该提示
(use-package git-gutter
  :ensure t
  :init
  (global-git-gutter-mode))


;;org-mode加强
(use-package org
  :ensure t
  :init
  (setq org-src-fontify-natively t)
  (setq org-hide-leading-stars t)
  (setq org-log-into-drawer t)
  (setq org-todo-keywords '((sequence "TODO(t)" "WAIT(w@/!)" "|" "DONE(d!)" "CANCELED(c@)")))
  (add-hook 'org-mode-hook
            (lambda ()
              (setq org-src-ask-before-returning-to-edit-buffer nil)
              (org-indent-mode 1))))
(use-package org-plus-contrib
  :ensure t)

(setq org-ellipsis "⤵")
(use-package org-bullets
  :ensure t
  :init
  (add-hook 'org-mode-hook 'org-bullets-mode))

(eval-after-load "org"
  '(require 'ox-md nil t))


(use-package ag
  :ensure t)


(defun user/company-clojure-init ()
  (bind-key "TAB" 'company-indent-or-complete-common clojure-mode-map)
  (bind-key "<tab>" 'company-indent-or-complete-common clojure-mode-map))

(defun user/company-cider-repl-init ()
  (bind-key "<tab>" 'company-complete-common cider-repl-mode-map))

(defun user/company-eshell-init ()
  (bind-key "<tab>" 'company-complete-common eshell-mode-map))

(defun user/company-elisp-init ()
  (bind-key "TAB" 'company-indent-or-complete-common emacs-lisp-mode-map)
  (bind-key "<tab>" 'company-indent-or-complete-common emacs-lisp-mode-map))

(use-package company
  :ensure t
  :bind
  (:map company-active-map
        ("<escape>" . company-abort)
        ("C-n" . company-select-next)
        ("C-p" . company-select-previous))
  :init
  (add-hook 'emacs-lisp-mode-hook #'user/company-elisp-init)
  (add-hook 'clojure-mode-hook #'user/company-clojure-init)
  (add-hook 'eshell-mode-hook #'user/company-eshell-init)
  (add-hook 'cider-repl-mode-hook #'user/company-cider-repl-init)
  (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
  (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion)
  (setq company-idle-delay nil)
  (global-company-mode))

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(use-package company-jedi
  :ensure t
  :init
  (add-hook 'python-mode-hook #'my/python-mode-hook)
  )

(use-package magit
  :ensure t
  :bind
  (("C-x M-g" . magit-dispatch-popup))
  :init
  (setq magit-completing-read-function 'ivy-completing-read)
  (global-magit-file-mode t))

(use-package hugsql-ghosts
  :ensure t
  :init
  (add-hook 'cider-mode-hook 'hugsql-ghosts-install-hook)
  )


(setq backup-directory-alist `(("." . "~/.backup")))

(setq backup-by-copying t)

(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)


;; Set font
(when window-system)

(set-fontset-font
 (frame-parameter nil 'font)
 'han
 (font-spec :family "Hiragino Sans GB"))


(global-set-key (kbd "<f10>") 'loop-alpha)
(setq alpha-list '((100 100) (95 65) (85 55) (75 45) (65 35)))  
(defun loop-alpha ()  
  (interactive)  
  (let ((h (car alpha-list)))                ;; head value will set to  
    ((lambda (a ab)  
       (set-frame-parameter (selected-frame) 'alpha (list a ab))  
       (add-to-list 'default-frame-alist (cons 'alpha (list a ab)))  
       ) (car h) (car (cdr h)))  
    (setq alpha-list (cdr (append alpha-list (list h))))))

;;主题
(use-package monokai-theme
  :ensure t)
(use-package molokai-theme
  :ensure t)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("3629b62a41f2e5f84006ff14a2247e679745896b5eaa1d5bcfbc904a3441b0cd" "ff7625ad8aa2615eae96d6b4469fcc7d3d20b2e1ebc63b761a349bebbb9d23cb" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "67e998c3c23fe24ed0fb92b9de75011b92f35d3e89344157ae0d544d50a63a72" default)))
 '(package-selected-packages
   (quote
    (molokai-theme monokai-theme monokai org-bullets company-jedi counsel-projectile InsideDotNet solarized-dark color-theme-solarized dracula-theme dracula molokai subtle-hacker solarized SOLARIZED ag git-gutter monroe rainbow-delimiters ace-window aggressive-indent projectile neotree exec-path-from-shell ivy cider clojure-mode zenburn-theme paredit company use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
