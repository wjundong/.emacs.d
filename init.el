;; 包管理
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (setq package-archives '(
			   ;;("melpa-cn" . "http://elpa.emacs-china.org/melpa/")
           		   ;;("org-cn" . "http://elpa.emacs-china.org/org/")
           		   ;;("gnu-cn" . "http://elpa.emacs-china.org/gnu/")
			   ("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
			   ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
			   ("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
			   )))


;;定义快速打开init.el的快捷键
(defun open-my-init-file ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
(global-set-key (kbd "<f5>") 'open-my-init-file)
;;================================================
;;          Emacs 内置基础设置
;;工具栏,菜单栏,滚动条,禁欢迎界面,org缩进
;;框选替换,括号匹配,行数标号,org导出Latex
;;================================================
(tool-bar-mode -1)
(menu-bar-mode 1)
(scroll-bar-mode -1)
(setq inhibit-splash-screen t)
(setq org-startup-indented t)
(delete-selection-mode t)
(show-paren-mode t)
;;(global-linum-mode t)
(setq-default cursor-type 'bar);修改光标
(setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
                              "xelatex -interaction nonstopmode %f"))
(add-hook 'org-mode-hook (lambda () (setq truncate-lines nil)));自动换行
(setq make-backup-files nil);禁止自动备份

(require 'org)
(setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))

(require 'ox-latex)
;;(add-to-list 'org-latex-classes
;;             '("elegantbook"
;;	       "\\documentclass[cn,11pt]{elegantbook}

;;	       ))

(add-to-list 'org-latex-classes
;;             '("elegantbook"
;;               "\\documentclass{elegantbook}"
;;               ("\\part{%s}" . "\\part*{%s}")
;;               ("\\chapter{%s}" . "\\chapter*{%s}")
;;               ("\\section{%s}" . "\\section*{%s}")
;;               ("\\subsection{%s}" . "\\subsection*{%s}")
;;               ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
;;	     '("IEEEtran"
;;	       "\\documentclass[10pt,journal,compsoc]{IEEEtran}"
;;	       ("\\section{%s}" . "\\section*{%s}")
;;               ("\\subsection{%s}" . "\\subsection*{%s}")
	     ;;               ("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
	     '("elegantpaper"
	       "\\documentclass[lang=cn,11pt]{elegantpaper}"
	        ("\\section{%s}" . "\\section*{%s}")
		("\\subsection{%s}" . "\\subsection*{%s}")
		("\\subsubsection{%s}" . "\\subsubsection*{%s}"))
             )

(setq org-export-latex-hyperref-format "\\ref{%s}")

;;===========================================
;;          使用use-package
;; 如果未安裝 use-package，安裝它
;;============================================
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))



(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  
  )


(use-package neotree
  :ensure t
  :bind (("C-c d" . neotree-dir)
	 ( "C-c s" . neotree)
	 ))


(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode)
  (use-package yasnippet-snippets :ensure t))


(use-package org-bullets
  :ensure t
  :init
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
  ;;(setq org-bullets-bullet-list '("☰" "☷" "☯" "☭"))
  )



(use-package swiper
  :ensure t
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "M-x") 'counsel-M-x)
  (global-set-key (kbd "C-x C-f") 'counsel-find-file)
  (global-set-key (kbd "<f1> f") 'counsel-describe-function)
  (global-set-key (kbd "<f1> v") 'counsel-describe-variable)

  (use-package counsel :ensure t)
  )


(use-package markdown-mode
  :ensure t
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


(use-package cnfonts
  :ensure t
  :init
  (cnfonts-enable)
  )

(use-package yaml-mode
  :ensure t
  )

(use-package cmake-mode
  :ensure t
  )

(use-package org-download
  :ensure t
  :init
  (require 'org-download)
  (add-hook 'dired-mode-hook 'org-download-enable)
  )

(use-package org-edit-latex
  :ensure t
  :init
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (latex . t)   ;; <== add latex to the list
     (python . t)
     (shell . t)
     (ruby . t)
     (perl . t)))
  )

(use-package company-auctex
  :ensure t
  :init
  (require 'company-auctex)
  (company-auctex-init)
  )

(use-package ebib
  :ensure t
  :init
  (org-add-link-type
 "cite" 'ebib
 (lambda (path desc format)
   (cond
    ((eq format 'html)
     (format "(<cite>%s</cite>)" path))
    ((eq format 'latex)
     (if (or (not desc) (equal 0 (search "cite:" desc)))
         (format "\\cite{%s}" path)
       (format "\\cite[%s][%s]{%s}"
               (cadr (split-string desc ";"))
               (car (split-string desc ";"))  path))))))
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(package-selected-packages (quote (use-package)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
