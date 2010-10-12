(define-structure sawflibs.tile.tiler
    (export tile-workspace
            register-workspace-tiler
            next-tiling
            setting
            set-setting)
    (open rep
          rep.system
          sawflibs.tile.utils)

  (define %tilers '())

  (define (register-workspace-tiler ws tiler args auto)
    (let ((curr (assoc ws %tilers))
          (new (list tiler args auto)))
      (if (null curr)
          (setq %tilers (cons (cons ws (list new) %tilers)))
        (setcdr curr (cons new (cdr curr))))))

  (define (next-tiling)
    (interactive)
    (when (rotate-tiling) (tile-workspace)))

  (define (rotate-tiling #!optional ws)
    (let ((ts (assoc (or ws current-workspace) %tilers)))
      (when (> (length ts) 2)
        (setcdr ts `(,@(cddr ts) ,(cadr ts))))))

  (define (tilings #!optional ws)
    (cdr (assoc (or ws current-workspace) %tilers)))

  (define (tiling #!optional ws)
    (car (tilings ws)))

  (define (tiling-tiler ti) (nth 0 ti))
  (define (tiling-auto-p ti) (nth 2 ti))
  (define (tiling-settings ti) (nth 1 ti))

  (define (tile-workspace #!optional new-window destroyed-window)
    (interactive)
    (let ((ti (tiling)))
      (when ti ((tiling-tiler ti) new-window destroyed-window))))

  (define (tileable-window-p w)
    (and (tiling-auto-p (tiling (window-workspace w)))
         (eq (window-type w) 'default)))

  (define (add-autotile w)
    (when (tileable-window-p w)
      (tile-workspace w)))

  (define (destroy-autotile w)
    (when (tileable-window-p w)
      (tile-workspace nil w)))

  (define (setting n #!optional def ws)
    (or (nth n (tiling-settings (tiling ws))) def))

  (define (set-setting n v #!optional ws)
    (let ((s (tiling-settings (tiling ws))))
      (when s (rplaca (nthcdr n s) v))))

  (add-hook 'after-add-window-hook add-autotile t)
  (add-hook 'destroy-notify-hook destroy-autotile t))
