
(define-structure sawflibs.tile
    (export align-workspace-windows
            tile-workspace
            untile-window
            next-tiling
            col-tiling
            tall-tiling
            tall-rotate-left
            tall-rotate-right
            increase-max-windows
            decrease-max-windows
	    increase-max-cols
	    decrease-max-cols
	    window-never-tile-p)
    (open rep
          rep.system
          sawflibs.tile.utils
          sawflibs.tile.tiler
          sawflibs.tile.tall
          sawflibs.tile.col))
