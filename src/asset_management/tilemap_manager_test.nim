import sprite_manager
import tilemap_manager
import sdl2
import sprite_manager
import os
import options
import print

proc test(): void = 
    discard sdl2.init(INIT_EVERYTHING)

    var window = createWindow("ECSy game", 100, 100, 640,480, SDL_WINDOW_SHOWN)
    var render = createRenderer(window, -1, Renderer_Accelerated or Renderer_PresentVsync or Renderer_TargetTexture)

    defer: destroy window
    defer: destroy render
    var tilemap_manager = newTileMapManager("assets/sprites/tilemaps", render)

    let tilemap = tilemap_manager.loadTilemap("devtilemap")

    print tilemap

test()