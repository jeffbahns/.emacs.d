; standard stuff
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/caroline-theme-20160317.2220/")
(load-theme 'caroline t)

; evil mode
(require 'evil)
(evil-mode 0)

; irony mode
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; replace the `completion-at-point' and `complete-symbol' bindings in
;; irony-mode's buffers by irony-mode's function
(defun my-irony-mode-hook ()
  (define-key irony-mode-map [remap completion-at-point]
    'irony-completion-at-point-async)
  (define-key irony-mode-map [remap complete-symbol]
    'irony-completion-at-point-async))
(add-hook 'irony-mode-hook 'my-irony-mode-hook)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

; doing minimal mode
(defun toggle-minimal-mode (fs)
  (interactive "P")
  (defun fullscreen-margins nil
    (if (and (window-full-width-p) (not (minibufferp)))
	(set-window-margins nil (/ (- (frame-width) 120) 2) (/ (- (frame-width) 120) 2))
      (mapcar (lambda (window) (set-window-margins window nil nil)) (window-list))))

  (cond (menu-bar-mode
	  (menu-bar-mode -1) (tool-bar-mode -1) (scroll-bar-mode -1)
	   (set-frame-height nil (+ (frame-height) 4))
	    (if fs (progn (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
						       '(1 "_NET_WM_STATE_FULLSCREEN" 0))
			         (add-hook 'window-configuration-change-hook 'fullscreen-margins))))
	(t (menu-bar-mode 1) (tool-bar-mode 1) (scroll-bar-mode 1)
	      (when (frame-parameter nil 'fullscreen)
		     (remove-hook 'window-configuration-change-hook 'fullscreen-margins)
		          (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
						     '(0 "_NET_WM_STATE_FULLSCREEN" 0))
			       (set-window-buffer (selected-window) (current-buffer)))
	         (set-frame-width nil (assoc-default 'width default-frame-alist)))))
(global-set-key [f5] 'toggle-minimal-mode)

; 4 spaced tabs
(setq c-basic-offset 4)
(setq lua-indent-level 4)
; line numbers
(global-linum-mode 1)
(setq linum-format "%d   ")

; neotrees
(add-to-list 'load-path "~/.emacs.d/neotree/")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)

; autopairing
(add-to-list 'load-path "~/.emacs.d/elpa/autopair-20160304.437/") ;; comment if autopair.el is in standard load path 
(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers

; nyan cat mode
(add-to-list 'load-path "~/.emacs.d/nyan-mode")
(require 'nyan-mode)

;(use-package nyan-mode
;  :init (nyan-mode 1))

; Goto line like in XEmacs:
(define-key global-map (kbd "M-g") 'goto-line)

 ;;;; This snippet enables lua-mode

;; This line is not necessary, if lua-mode.el is already on your load-path
(add-to-list 'load-path "~/.emacs.d/lua-mode/")

(autoload 'lua-mode "lua-mode" "Lua editing mode." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
(add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
