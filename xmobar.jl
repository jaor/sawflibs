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

  (define (status-string #!optional w)
    (let* ((w (or w (input-focus)))
           (name (adjust-width (if w (window-name w) "") %max-width))
           (ws (ws-string)))
       (format #f "%s %s" ws name)))

  (define %xmobar-proc (make-process))

  (define (start-xmobar cfg)
    (start-process %xmobar-proc "xmobar" cfg))

  (define (output-ws-status #!optional w ign)
    (format %xmobar-proc "%s\n" (status-string w)))

  (define %timer (make-timer (lambda (tm)
                               (output-ws-status)
                               (set-timer tm))))

  (define (activate-xmobar cfg #!key
                           (width 80)
                           (highlight "lightgoldenrod3")
                           (foreground "grey50"))
    (setq %max-width width)
    (setq %foreground foreground)
    (setq %hilite highlight)
    (start-xmobar cfg)
    (add-hook 'focus-in-hook output-ws-status)
    (add-hook 'window-state-change-hook output-ws-status)
    (set-timer %timer 1)))
