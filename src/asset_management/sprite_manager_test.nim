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

    var sprite_manager = newSpriteManager("assets/sprites", render)
    print spriteManager.loadAnimation("flaremage-stand-left")
    let my_sprite = sprite_manager.loadSprite("flaremage-stand-left")
    defer: sprite_manager.releaseSprite("flaremage-stand-left")

    var
        evt = sdl2.defaultEvent
        runGame = true

    while runGame:
        while pollEvent(evt):
            if evt.kind == QuitEvent:
                runGame = false
                break
        
        sleep(33)

        render.setDrawColor 0,0,0,255
        render.clear
        render.copy sprite_manager.getSprite("flaremage-stand-left").get().texture, nil, nil

        render.present
    

test()