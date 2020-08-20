;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Shafayet Khan"
      user-mail-address "shafayet_khan@comcast.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Mononoki" :size 15 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Noto Sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-dracula)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-agenda-files '("~/org"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Shafi's Config

;; UI
;; Open emacs Maximized on startup
(add-to-list 'initial-frame-alist '(fullscreen . maximized))

;; Org Super Agenda


(after! org
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "REVIEW(r)"
           "NEW(n)"
           "PRIORITIZED(p)"
           "IN-PROGRESS(i)"
           "BLOCKED(b)"
           "|"
           "READY-FOR-REVIEW(R)"
           "DONE(d)")
          (sequence
           "[ ](T)"
           "[-](S)"
           "[?](W)"
           "|"
           "[X](D)"))
        org-todo-keyword-faces
        '(("[-]"  . +org-todo-active)
          ("REVIEW" . +org-todo-active)
          ("NEW" . +org-todo-active)
          ("[?]"  . +org-todo-onhold)
          ("BLOCKED" . +org-todo-onhold)))
  (setq org-capture-templates
        '(("t" "Todo" entry (file "refile.org")
           "* TODO %?\n%u\n" :clock-in t :clock-resume t)
          ;; ("m" "Meeting" entry (file org-default-notes-file)
          ;;  "* MEETING with %? :MEETING:\n%t" :clock-in t :clock-resume t)
          ("r" "Review" entry (file "refile.org")
           "* Review %?\n%u\n%a\n" :clock-in t :clock-resume t)
          ("w" "Work" entry (file "work.org")
           "* NEW %?\n%u\n" :clock-in t :clock-resume t)
          ("d" "Diary" entry (file+olp+datetree "~/org/diary.org")
           "* %?\n%U\n" :clock-in t :clock-resume t)
          ("i" "Idea" entry (file "refile.org")
           "* %? :IDEA: \n%t" :clock-in t :clock-resume t)
          ("n" "Next Task" entry (file "refile.org")
           "* NEXT %? \nDEADLINE: %t")))
  )




(use-package! org-super-agenda
  :after org-agenda
  :init
  (setq org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-deadline-is-shown t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks nil ;; t hides the number of weeks which I like
      org-agenda-start-day nil ;; i.e. today
      org-agenda-span 1
      ;; org-agenda-tags-column -80
      ;; org-tags-column -80
      org-agenda-start-on-weekday nil)
  (setq org-agenda-custom-commands
        '(("X" "Super view"
           (
            (agenda "" (
                        ;; (org-agenda-overriding-header "")
                        (org-super-agenda-groups
                         '((:name "First Things First"
                            :priority "A"
                            :order 1
                            :discard
                            (:file-path("whoop\\.org"))
                            :discard
                            (:tag "refile"))
                           (:name "Today"
                            :order 2
                            :scheduled today
                            :scheduled past
                            :deadline today
                            :deadline past
                            )
                           ))))
            (tags-todo "-refile" ((org-agenda-overriding-header "")
                                  (org-super-agenda-groups
                                   '(
                                     (:name "Later"
                                      :scheduled future
                                      :scheduled future
                                      :order 1
                             :discard (:anything t)
                                      )))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-super-agenda-groups
                          '(
                            (:log t)
                            (:name "Refile"
                             :file-path("refile\\.org" "inbox\\.org")
                             :order 1)
                            (:name "Review"
                             :todo "REVIEW"
                             :order 2
                             :discard (:scheduled today
                                       :scheduled past
                                       :scheduled future
                                       :deadline today
                                       :deadline past
                                       :deadline future
                                       )
                             )
                            ))))))))
  :config
  (set-popup-rule! "\\*Org Agenda" :side 'bottom :size 0.60 :select t :ttl nil)
  (org-super-agenda-mode))

(map! :leader
      :desc "Org Super Agenda" "a" #'org-agenda)


(use-package! org-fancy-priorities
  :hook
  (org-mode . org-fancy-priorities-mode)
  :config
  (setq org-fancy-priorities-list '((?A . "❗")
                                    (?B . "⬆")
                                    (?C . "⬇")
                                    (?D . "☕")
                                    (?1 . "⚡")
                                    (?2 . "⮬")
                                    (?3 . "⮮")
                                    (?4 . "☕")
                                    (?I . "Important"))))
(setq +doom-dashboard-banner-dir "~/.doom.d/banners/"
      +doom-dashboard-banner-file "default.png")
