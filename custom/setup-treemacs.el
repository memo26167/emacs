(provide 'setup-treemacs)

(require 's)

(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))  
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if (treemacs--find-python3) 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-follow-delay             0.2
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-desc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-width                         20)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null (treemacs--find-python3))))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))

  )

;;;;;;;;;;;;
;;ICONOS;;;;
;;;;;;;,;;;;

;;;;doom-themes-ext-treemacs.el --- description -*- lexical-binding: t; no-byte-compile: t -*-

;;;;;DOOM THEME

(defgroup doom-themes-treemacs nil
  "Options for doom's treemacs theme"
  :group 'doom-themes)


;;
;;; Variables

(defcustom doom-themes-treemacs-enable-variable-pitch t
  "If non-nil, the labels for files, folders and projects are displayed with the
variable-pitch face."
  :type 'boolean
  :group 'doom-themes-treemacs)

(defcustom doom-themes-treemacs-line-spacing 1
  "Line-spacing for treemacs buffer."
  :type 'integer
  :group 'doom-themes-treemacs)


;;
;;; Library

(defun doom-themes-hide-fringes ()
  "Remove fringes in currnent window."
  (when (display-graphic-p)
    (set-window-fringes nil 0 0)))

(defun doom-themes-setup-tab-width (&rest _)
  "Set `tab-width' to 1, so tab characters don't ruin formatting."
  (setq tab-width 1))

(defun doom-themes-setup-line-spacing ()
  "Set `line-spacing' in treemacs buffers."
  (setq line-spacing doom-themes-treemacs-line-spacing))

(defun doom-themes-hide-modeline ()
  (setq mode-line-format nil))

(defun doom-themes-enable-treemacs-variable-pitch-labels (&rest _)
  (when doom-themes-treemacs-enable-variable-pitch
    (dolist (face '(treemacs-root-face
                    treemacs-git-unmodified-face
                    treemacs-git-modified-face
                    treemacs-git-renamed-face
                    treemacs-git-ignored-face
                    treemacs-git-untracked-face
                    treemacs-git-added-face
                    treemacs-git-conflict-face
                    treemacs-directory-face
                    treemacs-directory-collapsed-face
                    treemacs-file-face
                    treemacs-tags-face))
      (let ((faces (face-attribute face :inherit nil)))
        (set-face-attribute
         face nil :inherit
         `(variable-pitch ,@(delq 'unspecified (if (listp faces) faces (list faces)))))))))

(defun doom-themes-fix-treemacs-icons-dired-mode ()
  "Set `tab-width' to 1 in dired-mode if `treemacs-icons-dired-mode' is active."
  (if treemacs-icons-dired-mode
      (add-hook 'dired-mode-hook #'doom-themes-setup-tab-width nil t)
    (remove-hook 'dired-mode-hook #'doom-themes-setup-tab-width t)))


;;
;;; Bootstrap

(with-eval-after-load 'treemacs
  (unless (require 'all-the-icons nil t)
    (error "all-the-icons isn't installed"))

  (add-hook 'treemacs-mode-hook #'doom-themes-setup-tab-width)
  (add-hook 'treemacs-mode-hook #'doom-themes-setup-line-spacing)

  ;; Fix #293: tabs messing up formatting in `treemacs-icons-dired-mode'
  (add-hook 'treemacs-icons-dired-mode-hook #'doom-themes-fix-treemacs-icons-dired-mode)

  ;; The modeline isn't useful in treemacs
  ;;(add-hook 'treemacs-mode-hook #'doom-themes-hide-modeline)

  ;; Disable fringes (and reset them everytime treemacs is selected because it
  ;; may change due to outside factors)
  (add-hook 'treemacs-mode-hook #'doom-themes-hide-fringes)
  (advice-add #'treemacs-select-window :after #'doom-themes-hide-fringes)

  ;; variable-pitch labels for files/folders
  (doom-themes-enable-treemacs-variable-pitch-labels)
  (advice-add #'load-theme :after #'doom-themes-enable-treemacs-variable-pitch-labels)

  ;; minimalistic atom-inspired icon theme
  (treemacs-create-theme "doom"
    :config
    (let ((face-spec '(:inherit font-lock-doc-face :slant normal)))
      (treemacs-create-icon
       :icon (format " %s\t" (all-the-icons-octicon "repo" :v-adjust -0.1 :face face-spec))
       :extensions (root))
      (treemacs-create-icon
       :icon (format "%s\t%s\t"
                     (all-the-icons-octicon "chevron-down" :height 0.75 :v-adjust 0.1 :face face-spec)
                     (all-the-icons-octicon "file-directory" :v-adjust 0 :face face-spec))
       :extensions (dir-open))
      (treemacs-create-icon
       :icon (format "%s\t%s\t"
                     (all-the-icons-octicon "chevron-right" :height 0.75 :v-adjust 0.1 :face face-spec)
                     (all-the-icons-octicon "file-directory" :v-adjust 0 :face face-spec))
       :extensions (dir-closed))
      (treemacs-create-icon
       :icon (format "%s\t%s\t"
                     (all-the-icons-octicon "chevron-down" :height 0.75 :v-adjust 0.1 :face face-spec)
                     (all-the-icons-octicon "package" :v-adjust 0 :face face-spec)) :extensions (tag-open))
      (treemacs-create-icon
       :icon (format "%s\t%s\t"
                     (all-the-icons-octicon "chevron-right" :height 0.75 :v-adjust 0.1 :face face-spec)
                     (all-the-icons-octicon "package" :v-adjust 0 :face face-spec))
       :extensions (tag-closed))
      (treemacs-create-icon
       :icon (format "%s\t" (all-the-icons-octicon "tag" :height 0.9 :v-adjust 0 :face face-spec))
       :extensions (tag-leaf))
      (treemacs-create-icon
       :icon (format "%s\t" (all-the-icons-octicon "flame" :v-adjust 0 :face face-spec))
       :extensions (error))
      (treemacs-create-icon
       :icon (format "%s\t" (all-the-icons-octicon "stop" :v-adjust 0 :face face-spec))
       :extensions (warning))
      (treemacs-create-icon
       :icon (format "%s\t" (all-the-icons-octicon "info" :height 0.75 :v-adjust 0.1 :face face-spec))
       :extensions (info))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.png" :v-adjust 0))
       :extensions ("png" "jpg" "jpeg" "gif" "ico" "tif" "tiff" "svg" "bmp"
                    "psd" "ai" "eps" "indd"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.mp4" :v-adjust 0 ))
       :extensions ("mov" "avi" "mp4" "webm" "mkv"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.mp3" :v-adjust 0 ))
       :extensions ("wav" "mp3" "ogg" "midi"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.babelrc" :v-adjust 0 ))
       :extensions ("babelrc"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.bashrc" :v-adjust 0 ))
       :extensions ("bashrc"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.bowerrc" :v-adjust 0 ))
       :extensions ("bowerrc"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.dockerfile" :v-adjust 0 ))
       :extensions ("dockerfile"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "TODO" :v-adjust 0 ))
       :extensions ("TODO"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.c" :v-adjust 0 ))
       :extensions ("c"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.h" :v-adjust 0 ))
       :extensions ("h"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.clj" :v-adjust 0 ))
       :extensions ("clj"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.cljs" :v-adjust 0 ))
       :extensions ("cljs"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.cljc" :v-adjust 0 ))
       :extensions ("cljc"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.coffee" :v-adjust 0 ))
       :extensions ("coffee"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.cpp" :v-adjust 0 ))
       :extensions ("cpp"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.css" :v-adjust 0 ))
       :extensions ("css"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.dat" :v-adjust 0 ))
       :extensions ("dat"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.pdf" :v-adjust 0 ))
       :extensions ("pdf"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.el" :v-adjust 0 ))
       :extensions ("el"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.eex" :v-adjust 0 ))
       :extensions ("eex"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.ex" :v-adjust 0 ))
       :extensions ("ex"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.exs" :v-adjust 0 ))
       :extensions ("exs"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.elm" :v-adjust 0 ))
       :extensions ("elm"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.erl" :v-adjust 0 ))
       :extensions ("erl"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.hrl" :v-adjust 0 ))
       :extensions ("hrl"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.go" :v-adjust 0 ))
       :extensions ("go"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.js" :v-adjust 0 ))
       :extensions ("js"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.hbs" :v-adjust 0 ))
       :extensions ("hbs"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.hs" :v-adjust 0 ))
       :extensions ("hs"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.erb" :v-adjust 0 ))
       :extensions ("erb"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.haml" :v-adjust 0 ))
       :extensions ("haml"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.slim" :v-adjust 0 ))
       :extensions ("slim"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.java" :v-adjust 0 ))
       :extensions ("java"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.jsx" :v-adjust 0 ))
       :extensions ("jsx"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.jl" :v-adjust 0 ))
       :extensions ("jl"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.log" :v-adjust 0 ))
       :extensions ("log"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.md" :v-adjust 0 ))
       :extensions ("md"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.lock" :v-adjust 0 ))
       :extensions ("lock"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.ml" :v-adjust 0 ))
       :extensions ("ml"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.mli" :v-adjust 0 ))
       :extensions ("mli"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.org" :v-adjust 0 ))
       :extensions ("org"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.json" :v-adjust 0 ))
       :extensions ("json"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.pl" :v-adjust 0 ))
       :extensions ("pl"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.php" :v-adjust 0 ))
       :extensions ("php"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.py" :v-adjust 0 ))
       :extensions ("py"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.re" :v-adjust 0 ))
       :extensions ("rei"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.rei" :v-adjust 0 ))
       :extensions ("rei"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.rb" :v-adjust 0 ))
       :extensions ("rb"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.scss" :v-adjust 0 ))
       :extensions ("scss"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.scala" :v-adjust 0 ))
       :extensions ("scala"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.cson" :v-adjust 0 ))
       :extensions ("cson"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.yml" :v-adjust 0 ))
       :extensions ("yml"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.fish" :v-adjust 0 ))
       :extensions ("fish"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.zsh" :v-adjust 0 ))
       :extensions ("zsh"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.styl" :v-adjust 0 ))
       :extensions ("styl"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.swift" :v-adjust 0 ))
       :extensions ("swift"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.ext" :v-adjust 0 ))
       :extensions ("ext"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.txt" :v-adjust 0 ))
       :extensions ("txt"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.ts" :v-adjust 0 ))
       :extensions ("ts"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.r" :v-adjust 0 ))
       :extensions ("r"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.sh" :v-adjust 0 ))
       :extensions ("sh"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.html" :v-adjust 0 ))
       :extensions ("html"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "makefile" :v-adjust 0 ))
       :extensions ("makefile"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-icon-for-file "file.awk" :v-adjust 0 ))
       :extensions ("awk"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-octicon "file-code" :v-adjust 0))
       :extensions ("yaml" "cxx" "hpp"
                    "tpp" "cc" "hh"  "lhs" "cabal"  "pyc" "rs"
                    "elc" "tsx" "vue"
                    "htm" "dart"  "kt" "sbt"  
                    "hy" "pp"
                    "vagrantfile" "j2" "jinja2" "tex" "racket" "rkt" "rktl" "rktd"
                    "scrbl" "scribble" "plt" "makefile" "xml" "xsl"
                    "lua" "lisp" "scm" "sql" "toml" "nim"  "pm" "perl"
                    "vimrc" "tridactylrc" "vimperatorrc" "ideavimrc" "vrapperrc"
                    "cask"  "zshrc" "inputrc" "editorconfig"
                    "gitconfig"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-octicon "book" :v-adjust 0))
       :extensions ("lrf" "lrx" "cbr" "cbz" "cb7" "cbt" "cba" "chm" "djvu"
                    "doc" "docx" "pdb" "pdb" "fb2" "xeb" "ceb" "inf" "azw"
                    "azw3" "kf8" "kfx" "lit" "prc" "mobi" "or"
                    "pkg" "opf" "txt" "pdb" "ps" "rtf" "pdg" "xml" "tr2"
                    "tr3" "oxps" "xps"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-octicon "file-text" :v-adjust 0))
       :extensions ( "markdown" "rst"  "txt"
                     "CONTRIBUTE" "LICENSE" "README" "CHANGELOG"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-octicon "file-binary" :v-adjust 0))
       :extensions ("exe" "dll" "obj" "so" "o" "out"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-octicon "file-zip" :v-adjust 0))
       :extensions ("zip" "7z" "tar" "gz" "rar" "tgz"))
      (treemacs-create-icon
       :icon (format "  %s\t" (all-the-icons-octicon "file-text" :v-adjust 0))
       :extensions (fallback))))

  (treemacs-load-theme "doom"))

(require 'golden-ratio)
(add-to-list 'golden-ratio-exclude-modes 'treemacs-mode)
