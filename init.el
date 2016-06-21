; theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/elpa/caroline-theme-20160317.2220/")
(load-theme 'caroline t)

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

; line numbers
(global-linum-mode 1)
(setq linum-format "%d   ")

;
(add-to-list 'load-path "~/.emacs.d/neotree")
(require 'neotree)
(global-set-key [f8] 'neotree-toggle)
