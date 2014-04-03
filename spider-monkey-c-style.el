;;; spider-monkey-c-style.el --- SpiderMonkey Coding Style draft for c-mode

;; Keywords: c, tools

;; spider-monkey-c-style.el is created by arai (arai_a@mac.com).
;;
;; It is based on google-c-style.el, Copyright (C) 2008 Google Inc.
;; All Rights Reserved.
;;   http://google-styleguide.googlecode.com/svn/trunk/google-c-style.el
;;
;; It is free software; you can redistribute it and/or modify it under the
;; terms of either:
;;
;; a) the GNU General Public License as published by the Free Software
;; Foundation; either version 1, or (at your option) any later version, or
;;
;; b) the "Artistic License".

;;; Commentary:

;; This script is draft, and there may be wrong styling.
;;
;; Provides the SpiderMonkey Coding Style draft. You may wish to add
;; `spider-monkey-set-c-style' to your `c-mode-common-hook' after requiring
;; this file. For example:
;;
;;    (add-hook 'c-mode-common-hook 'spider-monkey-set-c-style)

;;; Code:

;; For some reason 1) c-backward-syntactic-ws is a macro and 2)  under Emacs 22
;; bytecode cannot call (unexpanded) macros at run time:
(eval-when-compile (require 'cc-defs))

(defun consume-re (re n)
  "if re matches, skip it and trailing whitespaces"
  (when (looking-at re)
    (goto-char (match-end n))
    (c-forward-comments)
    t))

(defun consume-pointer ()
  (while (consume-re "\\*" 0))
  (while (consume-re "\\[\\]" 0)))

(defun consume-template ()
  (when (consume-re "<" 0)
    (when (consume-type)
      (cond
       ((looking-at ",")
        (while (and (consume-re "," 0)
                    (consume-type)))
        (consume-re ">" 0))
       (t
        (consume-re ">" 0))))))

(defun consume-type ()
  (cond
   ((consume-re c-primitive-type-key 1)
    ;; unsigned long int
    (while (consume-re c-primitive-type-key 1))
    (consume-pointer)
    t)
   (t
    ;; struct
    (consume-re c-type-prefix-key 1)
    ;; foo
    (when (consume-re c-identifier-key 0)
      ;; <A,B>
      (consume-template)
      (consume-pointer)
      t))))

(defun current-line-starts-with-label-kwds ()
  (save-excursion
    (goto-char startpos)
    (looking-at c-label-kwds-regexp)))

(defun current-line-starts-with-brace-open ()
  (save-excursion
    (goto-char startpos)
    (c-forward-comments)
    (eq (following-char) ?{)))

(defun previous-line-ends-with-colon ()
  (save-excursion
    (goto-char startpos)
    (c-backward-comments)
    (eq (char-before) ?:)))

(defun previous-line-starts-with-label-kwds ()
  (save-excursion
    (goto-char startpos)
    (c-backward-comments)
    (beginning-of-line)
    (c-forward-comments)
    (looking-at c-label-kwds-regexp)))

(defun spider-monkey-c-lineup-case-block-intro (langelem)
  "Line up first line of case/default block. E.g.:

switch (v) {
  case L1: {
    break;          <- spider-monkey-c-lineup-case-block-intro
  }
  default: {
    break;          <- spider-monkey-c-lineup-case-block-intro
  }
}
switch (v) {
  case L1:
  {
    break;          <- spider-monkey-c-lineup-case-block-intro
  }
  default:
  {
    break;          <- spider-monkey-c-lineup-case-block-intro
  }
}
"
  (save-excursion
    (let ((startpos (c-langelem-pos langelem)))
      (goto-char startpos)
      (cond
       ((current-line-starts-with-label-kwds)
        ;; case: {
        (/ c-basic-offset 2))
       ((and (current-line-starts-with-brace-open)
             (previous-line-ends-with-colon)
             (previous-line-starts-with-label-kwds))
        ;; case:
        ;; {
        (/ c-basic-offset 2))))))

(defun line-starts-with-conditional (pos)
  (save-excursion
    (goto-char pos)
    (c-forward-comments)
    (or (eq (following-char) ?:)
        (eq (following-char) ??))))

(defun check-conditional-lines (startpos endpos)
  (save-excursion
    (goto-char endpos)
    (let ((result t)
          (pos endpos))
      (while (>= pos startpos)
        (cond
         ((line-starts-with-conditional pos)
          (goto-char pos)
          (forward-line -1)
          (setq pos (point)))
         (t
          (setq result nil)
          (setq pos -1))))
      result)))

(defun spider-monkey-c-lineup-fix-wrong-cont (langelem)
  "Fix wrong statement-cont on following code:
switch (v) {
  case L1:
    if (t)
      x = foo ? bar : baz;
    goto L2;       <- spider-monkey-c-lineup-fix-wrong-cont
}
"
  (save-excursion
    (let ((bol (c-point 'bol)))
      (goto-char bol)
      (c-backward-comments)
      (when (eq (char-before) ?\;)
        (- 0 c-basic-offset)))))

(defun spider-monkey-c-lineup-conditional-cont (langelem)
  "Line up second line of conditional expression. E.g.:

x = a ? b
      : c;          <- spider-monkey-c-lineup-conditional-cont
x = a
  ? b               <- spider-monkey-c-lineup-conditional-cont
  : c;              <- spider-monkey-c-lineup-conditional-cont
x =
    a
    ? b             <- NOT spider-monkey-c-lineup-conditional-cont
    : c;            <- NOT spider-monkey-c-lineup-conditional-cont
"
  (save-excursion
    (let ((startpos (c-langelem-pos langelem))
          (bol (c-point 'bol))
          (eol (c-point 'eol)))
      (when (check-conditional-lines startpos bol)
        (goto-char bol)
        (c-forward-comments)
        (let ((start-char (following-char)))
          (cond
           ((eq start-char ?:)
            ;; foo = x ? y
            ;;         : z;
            ;; //     (^ here)
            (goto-char startpos)
            (when (c-syntactic-re-search-forward "\\?" eol t t t)
              (goto-char (match-beginning 0))
              (let ((eq-col (current-column)))
                (goto-char startpos)
                (- eq-col (current-column)))))
           ((eq start-char ??)
            ;; foo = x
            ;;     ? y
            ;; // (^ here)
            ;;     : z;
            (goto-char startpos)
            (when (c-syntactic-re-search-forward
                   c-assignment-op-regexp eol t t t)
              (let ((eq-first (match-beginning 0))
                    (eq-last (- (match-end 0) 1))
                    eq-col)
                (goto-char eq-first)
                (cond
                 ((eq (following-char) ?=)
                  ;; foo = x
                  ;;     ? y
                  ;;     : z;
                  (setq eq-col (current-column)))
                 (t
                  ;; foo += x
                  ;;      ? y
                  ;;      : z;
                  (goto-char eq-last)
                  (setq eq-col (current-column))))
                (goto-char startpos)
                (- eq-col (current-column)))))))))))

(defun spider-monkey-c-lineup-defvar-cont (langelem)
  "Line up second line of variable definition. E.g.:

unsigned int *a,
              b;   <- spider-monkey-c-lineup-defvar-cont
struct foo *a,
            b;     <- spider-monkey-c-lineup-defvar-cont
bar<baz*> a,
          b;       <- spider-monkey-c-lineup-defvar-cont
"
  (save-excursion
    (let ((startpos (c-langelem-pos langelem))
          (bol (c-point 'bol)))
      (goto-char bol)
      (c-backward-comments)
      (when (eq (char-before) ?,)
        (goto-char startpos)
        (when (consume-type)
          (when (looking-at c-identifier-key)
            (goto-char (match-beginning 0))
            (let ((before-col (current-column)))
              (goto-char startpos)
              (- before-col (current-column)))))))))

(defun spider-monkey-c-lineup-return-cont (langelem)
  "Line up second line of return statement. E.g.:
return X &&
       Y;           <- spider-monkey-c-lineup-return-cont
"
  (save-excursion
    (let ((startpos (c-langelem-pos langelem))
          (bol (c-point 'bol)))
      (goto-char startpos)
      (when (consume-re "return" 0)
        (let ((rv-col (current-column)))
          (goto-char startpos)
          (- rv-col (current-column)))))))

(defconst spider-monkey-c-style
  `((c-basic-offset . 4)
    (indent-tabs-mode . nil)
    (c-comment-only-line-offset . 0)
    (c-offsets-alist
     . (;; -- from Wiki --
        ;; https://wiki.mozilla.org/JavaScript:SpiderMonkey:Coding_Style

        ;; switch (discriminant) {
        ;;   case L1:               <- case-label
        ;;     DoSomething();       <- statement-case-intro
        ;;     ...
        ;; }
        (case-label . *)
        (statement-case-intro . *)

        ;; class Ninja
        ;;   : public WeaponWeilder,  <- inher-intro
        ;;     public Camouflagible
        ;; {
        ;;     Ninja()
        ;;       : WeaponWeilder(Weapons::SHURIKEN),  <- member-init-intro
        ;;         Camouflagibley(Garments::SHINOBI_SHOZOKU) {}
        ;; };
        (inher-intro . *)
        (member-init-intro . *)

        ;; -- From existing code --

        ;; if (foo)
        ;; {                        <- substatement-open
        ;;     bar();
        ;; }
        (substatement-open . 0)

        ;; switch (v) {
        ;;   case L1: {
        ;;     break;               <- spider-monkey-c-lineup-case-block-intro
        ;;   }
        ;;   case L2:
        ;;   {
        ;;     break;               <- spider-monkey-c-lineup-case-block-intro
        ;;   }
        ;; }
        (statement-block-intro . (spider-monkey-c-lineup-case-block-intro
                                  +))

        ;; class foo
        ;; {
        ;;   public:                <- access-label
        ;;     foo();
        ;; };
        (access-label . /)

        ;; {
        ;;   label:                 <- label
        ;;     return;
        ;; }
        (label . *)

        ;; do not indent inside extern and namespace
        (inextern-lang 0)
        (innamespace 0)

        ;; foo.bar()
        ;;    .baz();               <- c-lineup-cascaded-calls
        ;; foo = x ? y
        ;;         : z;             <- spider-monkey-c-lineup-conditional-cont
        ;; x = a
        ;;   ? b                    <- spider-monkey-c-lineup-conditional-cont
        ;;   : c;                   <- spider-monkey-c-lineup-conditional-cont
        ;; foo = bar &&
        ;;       baz;               <- c-lineup-assignments
        ;; unsigned int *a,
        ;;               b;         <- spider-monkey-c-lineup-defvar-cont
        ;; return X &&
        ;;        Y;                <- spider-monkey-c-lineup-return-cont
        (statement-cont . (spider-monkey-c-lineup-fix-wrong-cont
                           c-lineup-cascaded-calls
                           spider-monkey-c-lineup-conditional-cont
                           c-lineup-assignments
                           spider-monkey-c-lineup-defvar-cont
                           spider-monkey-c-lineup-return-cont
                           +))
        (topmost-intro-cont . (spider-monkey-c-lineup-defvar-cont
                               0))

        ;; int
        ;; foo()
        ;; const                    <- func-decl-cont
        ;; {
        ;; }
        ;;
        ;; To avoid indent second line of following:
        ;;   1: extern JS_FRIEND_API(int)
        ;;   2: js_fgets(char *buf, int size, FILE *file);
        (func-decl-cont . 0)

        ;; -- Maybe --

        ;; class foo
        ;; {
        ;;     hoge()
        ;;     {                    <- inline-open
        ;;     }
        ;; };
        (inline-open . 0)
        )))
  "SpiderMonkey Coding Style draft.")

(defun spider-monkey-set-c-style ()
  "Set the current buffer's c-style to SpiderMonkey Coding Style.
  Meant to be added to `c-mode-common-hook'."
  (interactive)
  (make-local-variable 'c-tab-always-indent)
  (setq c-tab-always-indent t)
  (c-add-style "SpiderMonkey" spider-monkey-c-style t))

(provide 'spider-monkey-c-style)

;;; spider-monkey-c-style.el ends here
