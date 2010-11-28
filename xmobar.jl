(define-structure sawflibs.xmobar
  (export activate-xmobar)

  (open rep
        rep.system
        rep.io.processes
        rep.io.timers
        sawfish.wm.windows
        sawfish.wm.workspace)

  (define %max-width 80)
  (define %foreground "")
  (define %hilite "")

  (define (xmobar-fg color txt)
    (format #f "<fc=%s>%s</fc> " color txt))

  (define (ws-string)
    (apply concat
           (mapcar (lambda (n)
                     (xmobar-fg (if (equal n current-workspace) %hilite
                                  %foreground)
                                (if (numberp n) (1+ n) n)))
                   (sort (cons current-workspace
                               (remove current-workspace
                                       (all-workspaces)))))))

  (define (adjust-width s m)
    (if (> (length s) m)
        (concat (substring s 0 (- m 3)) "...")
      s))

  (define (status-string w)
    (let ((name (adjust-width (if w (window-name w) "") %max-width))
          (ws (ws-string)))
       (format #f "%s %s" ws name)))

  (define %xmobar-proc nil)

  (define (start-xmobar cfg)
    (when %xmobar-proc (kill-process %xmobar-proc))
    (setq %xmobar-proc (make-process))
    (start-process %xmobar-proc "xmobar" cfg))

  (define (output-ws-status w)
    (format %xmobar-proc "%s\n" (status-string w)))

  (define (focus-hook w #!rest ign)
    (output-ws-status w))

  (define (property-hook w #!rest ign)
    (when (eq w (input-focus)) (output-ws-status w)))

  (define (enter-ws-hook wsl)
    (when (workspace-empty-p (car wsl)) (output-ws-status nil)))

  (define (activate-xmobar cfg #!key
                           (width 80)
                           (highlight "lightgoldenrod3")
                           (foreground "grey50"))
    (setq %max-width width)
    (setq %foreground foreground)
    (setq %hilite highlight)
    (unless %xmobar-proc
      (add-hook 'focus-in-hook focus-hook)
      (add-hook 'property-notify-hook property-hook)
      (add-hook 'enter-workspace-hook enter-ws-hook))
    (start-xmobar cfg)))
