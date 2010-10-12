
(define-structure sawflibs.tile
    (export align-workspace-windows
            tile-workspace
            next-tiling
            increase-max-windows
            decrease-max-windows
            tall-tiling
            col-tiling)
    (open rep
          rep.system
          sawflibs.tile.utils
          sawflibs.tile.tiler
          sawflibs.tile.tall
          sawflibs.tile.col))

